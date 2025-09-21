// FREE TIER Lambda function for DynamoDB operations
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, GetCommand, PutCommand, ScanCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({ region: process.env.AWS_REGION });
const docClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event) => {
    console.log('Event:', JSON.stringify(event, null, 2));
    
    const headers = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, X-Api-Key, Authorization'
    };

    try {
        const httpMethod = event.httpMethod;
        const resource = event.resource;
        const tableName = process.env.DYNAMO_TABLE;

        // Handle CORS preflight
        if (httpMethod === 'OPTIONS') {
            return {
                statusCode: 200,
                headers,
                body: JSON.stringify({ message: 'CORS preflight success' })
            };
        }

        // GET /users - List all users (FREE TIER optimized with limit)
        if (httpMethod === 'GET' && resource === '/users') {
            const limit = event.queryStringParameters?.limit ? 
                parseInt(event.queryStringParameters.limit) : 25; // FREE TIER: limit scan results
                
            const command = new ScanCommand({
                TableName: tableName,
                Limit: limit
            });
            
            const result = await docClient.send(command);
            return {
                statusCode: 200,
                headers,
                body: JSON.stringify({
                    users: result.Items || [],
                    count: result.Count,
                    scannedCount: result.ScannedCount
                })
            };
        }

        // GET /users/{id} - Get specific user
        if (httpMethod === 'GET' && resource === '/users/{id}') {
            const userId = event.pathParameters.id;
            
            const command = new GetCommand({
                TableName: tableName,
                Key: { userId }
            });
            
            const result = await docClient.send(command);
            
            if (!result.Item) {
                return {
                    statusCode: 404,
                    headers,
                    body: JSON.stringify({ message: 'User not found' })
                };
            }
            
            return {
                statusCode: 200,
                headers,
                body: JSON.stringify(result.Item)
            };
        }

        // POST /users - Create new user
        if (httpMethod === 'POST' && resource === '/users') {
            const body = JSON.parse(event.body);
            const userId = Date.now().toString(); // Simple ID generation
            
            const user = {
                userId,
                name: body.name,
                email: body.email,
                createdAt: new Date().toISOString()
            };
            
            const command = new PutCommand({
                TableName: tableName,
                Item: user
            });
            
            await docClient.send(command);
            
            return {
                statusCode: 201,
                headers,
                body: JSON.stringify(user)
            };
        }

        // Method not allowed
        return {
            statusCode: 405,
            headers,
            body: JSON.stringify({ message: 'Method not allowed' })
        };

    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            headers,
            body: JSON.stringify({ 
                message: 'Internal server error',
                error: process.env.NODE_ENV === 'development' ? error.message : undefined
            })
        };
    }
};