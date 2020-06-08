console.log('Loading function');

exports.handler = async (event, context, callback) => {

    var response = {
        statusCode: 200,
        headers: {
            'Access-Control-Allow-Origin': 'https://api.designguide.me',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'OPTIONS,POST'
        },
        body: JSON.stringify(event)
    };

    context.succeed(response);
};