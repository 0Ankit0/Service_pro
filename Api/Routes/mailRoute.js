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
                res.status(200).send({ message: 'Email sent successfully ' });
            }
        });
    } catch (error) {
        req.status(500).send({ message: error });
    }

});
export default mailRouter;
