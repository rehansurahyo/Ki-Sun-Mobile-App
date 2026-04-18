const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');
const path = require('path');

// Manually defining spec for now, or load from yaml
const swaggerDocument = {
    openapi: '3.0.0',
    info: {
        title: 'Ki-Sun API',
        version: '1.0.0',
        description: 'API Documentation for Ki-Sun Tanning Studio App'
    },
    servers: [
        {
            url: 'https://ki-sun-app-backend.vercel.app/api',
            description: 'Local Development Server'
        }
    ],
    components: {
        securitySchemes: {
            bearerAuth: {
                type: 'http',
                scheme: 'bearer',
                bearerFormat: 'JWT'
            }
        }
    },
    paths: {
        '/users/pre-account': {
            post: {
                summary: 'Create a pre-account for a new device',
                tags: ['Users'],
                requestBody: {
                    required: true,
                    content: {
                        'application/json': {
                            schema: {
                                type: 'object',
                                properties: {
                                    device_uuid: { type: 'string' },
                                    studio_id: { type: 'string' },
                                    campaign_id: { type: 'string' }
                                }
                            }
                        }
                    }
                },
                responses: {
                    201: {
                        description: 'Pre-account created'
                    }
                }
            }
        }
    }
};

module.exports = { swaggerUi, swaggerDocument };
