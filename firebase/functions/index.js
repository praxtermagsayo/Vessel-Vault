const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sgMail = require('@sendgrid/mail');

admin.initializeApp();
sgMail.setApiKey('YOUR_SENDGRID_API_KEY');

exports.sendOtpEmail = functions.firestore
    .document('pending_registrations/{docId}')
    .onCreate((snap, context) => {
        const data = snap.data();
        const msg = {
            to: data.email,
            from: 'your-email@example.com',
            subject: 'Your OTP Code',
            text: `Your OTP code is ${data.otp}`,
        };
        return sgMail.send(msg);
    }); 