const simpleParser = require('mailparser').simpleParser;
const {
    SESClient,
    SendEmailCommand
} = require("@aws-sdk/client-ses");
// configure sesClient
const sesConfig = {
    region: process.env.AWS_REGION
};
const sesClient = new SESClient(sesConfig);

exports.handler = async (event) => {
    const message = JSON.parse(event.Records[0].Sns.Message);
    const source = process.env.email;
    const destination = message.mail.destination[0];
    // console.log(destination); return;
    let body = Buffer.from(message.content, 'base64');
    const mail = await simpleParser(body);

    const sesInput = {
        Destination: {
            ToAddresses: [
                source, //RECEIVER_ADDRESS
            ]
        },
        Message: {
            Body: {
                Html: {
                    Charset: "UTF-8",
                    Data: mail.html
                },
                Text: {
                    Charset: "UTF-8",
                    Data: mail.text
                },
            },
            Subject: {
                Charset: "UTF-8",
                Data: "email received at " + destination + " with subject: " + mail.subject
            },
        },
        Source: destination // SENDER_ADDRESS
    };
    const sesCommand = new SendEmailCommand(sesInput);
    const sesResponse = await sesClient.send(sesCommand);

};