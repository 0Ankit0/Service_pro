import { Router } from "express";
import nodemailer from "nodemailer";
import { Mail } from "../Modals/mail.js";
import { generateUniqueCode } from "../Modals/mail.js";
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
                res.status(400).send(error.message);
            } else {
                res.status(200).send({ message: 'Email sent successfully ' });
            }
        });
    } catch (error) {
        req.status(500).send({ message: error.message });
    }

});
mailRouter.post('/send/welcome', async (req, res) => {
    try {
        const link = `http://20.52.185.247:8000/user/verifyAccount?id=${req.body.id}`;
        const { Email } = req.body;

        const mailOptions = {
            from: 'serviceapp@ankitpdl.me', // replace with your email
            to: Email, // recipient's email
            subject: 'Welcome To Service App', // replace with your subject
            template: "welcome",
            'h:X-Mailgun-Variables': { link: link }
        };

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.log(error);
                res.status(400).send(error.message);
            } else {
                Mail.create({ Email, Body: 'Welcome', Name: link }).then(() => {
                    res.status(200).send({ message: 'Email sent successfully ' });
                }).catch((error) => {
                    res.status(400).send({ message: error.message });
                });
            }
        });
    } catch (error) {
        req.status(500).send({ message: error.message });
    }
});

mailRouter.post('/send/resetPassword', async (req, res) => {
    try {
        const { Email } = req.body;
        const Code = await generateUniqueCode();
        const mailOptions = {
            from: 'serviceapp@ankitpdl.me', // replace with your email
            to: Email, // recipient's email
            subject: 'Password Reset', // replace with your subject
            template: "resetpassword",
            'h:X-Mailgun-Variables': { code: Code }
        };

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.log(error);
                res.status(500).send(error);
            } else {
                Mail.create({ Email, Body: 'password reset', Code }).then(() => {
                    res.status(200).send({ message: 'Email sent successfully ', data: Code });
                }).catch((error) => {
                    res.status(500).send({ message: error.message });
                });
            }
        });
    } catch (error) {
        req.status(500).send({ message: error });
    }

});
export default mailRouter;
