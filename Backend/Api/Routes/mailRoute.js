import { Router } from "express";
import nodemailer from "nodemailer";
import { Mail } from "../Modals/mail";

const mailRouter = Router();


mailRouter.post('/send', async (req, res) => {
    const { Email, Body } = req.body;

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
        to: Email,
        subject: 'Mail Subject',
        text: Body
    };

    try {
        // Send the mail
        await transporter.sendMail(mailOptions);
        Mail.create({ Email, Body });
        res.send("Mail sent successfully");
    } catch (error) {
        console.error(error);
        res.status(500).send("Failed to send mail");
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
        res.status(500).send("Failed to send mail");
    }
});
export default mailRouter;
