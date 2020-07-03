console.log('Loading function');
var AWS = require('aws-sdk');

var lambda = new AWS.Lambda();
exports.handler = function(event, context) {
    key = event.Records[0].s3.object.key
    bucket = event.Records[0].s3.bucket.name
    version = event.Records[0].s3.object.versionId
    functionName = key.substring(0, key.lastIndexOf(".zip"));

    console.log(`key = ${key}`)
    console.log(`bucket = ${bucket}`)
    console.log(`version = ${version}`)

    console.log("Updating lambda function " + functionName);

    var params = {
        FunctionName: functionName,
        S3Key: key,
        S3Bucket: bucket,
        S3ObjectVersion: version
    };
    lambda.updateFunctionCode(params, (err, data) => {
        if (err) {
            console.log(err, err.stack);
            context.fail(err);
        } else {
            console.log(data);
            context.succeed(data);
        }
    });
};