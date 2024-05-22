import { Router } from "express";
import nodemailer from "nodemailer";
import { Mail } from "../Modals/mail.js";
import * as dotenv from 'dotenv';
import mg from 'nodemailer-mailgun-transport';
dotenv.config();

const mailRouter = Router();

const auth = {
    auth: {
        api_key: process.env.MAILGUN_API_KEY,
        domain: process.env.MAILGUN_DOMAIN
    }
}
const transporter = nodemailer.createTransport(mg(auth));

mailRouter.post('/send', async (req, res) => {
    try {
        const { Email, Body } = req.body;

        const mailOptions = {
            from: 'serviceapp@ankitpdl.me', // replace with your email
            to: Email, // recipient's email
            subject: 'Mail Subject', // replace with your subject
            text: Body // email body
        };

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.log(error);
                res.status(500).send(error);
            } else {
                console.log('Email sent: ' + info.response);
                res.status(200).send('Email sent successfully ');
            }
        });
    } catch (error) {
        req.status(500).send(error);
    }

});
mailRouter.post('/send-multiple', async (req, res) => {
    const { EmailAddresses, Body } = req.body;

    // Create a transporter using SMTP
    // const transporter = nodemailer.createTransport({
    //     host: 'smtp.example.com',
    //     port: 587,
    //     secure: false,
    //     auth: {
    //         user: 'your-email@example.com',
    //         pass: 'your-password'
    //     }
    // });
    //Or
    //Create a transporter Using Gmail and ensure that you have enabled "Less secure apps" in your Google account settings
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'your_email@gmail.com',
            pass: 'your_email_password',
        },
    });

    // Define the mail options
    const mailOptions = {
        from: 'your-email@example.com',
        to: EmailAddresses.join(', '), // Join the email addresses with a comma
        subject: 'Mail Subject',
        text: emailBody
    };

    try {
        // Send the mail
        await transporter.sendMail(mailOptions);
        Mail.create({ Email: EmailAddresses, Body: emailBody });
        res.send("Mail sent successfully");
    } catch (error) {
        console.error(error);
        res.status(400).send("Failed to send mail");
    }
});
export default mailRouter;
