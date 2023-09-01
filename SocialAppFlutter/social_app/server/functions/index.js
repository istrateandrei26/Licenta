const functions = require("firebase-functions");
const stripe = require('stripe')(functions.config().stripe.testkey)

const calculateOrderAmount = (items) => {
    var dolars = 100;
    return 1 * dolars;    
}

const generateResponse = (intent) => {
    switch (intent.status) {
        case 'requires_action':
            return {
                clientSecret: intent['client_secret'],
                requiresAction: true,
                status: intent.status
            };
        
        case 'requires_payment_method':
            return {
                'error': 'Your card was denied, please provide a new payment method',
            };
        
        case 'succeeded':
            console.log('Payment succeeded');
            console.log("Client secret: " + intent['client_secret']);
            return {clientSecret: intent['client_secret'], status: intent.status};
    
        default:
            break;
    }
    return {error: 'Failed'};
}

exports.StripePayEndpointMethodId = functions.https.onRequest(async (req, res) => {
    const { paymentMethodId, items, currency, useStripeSdk } = req.body;

    const orderAmount = calculateOrderAmount(items);

    try {
        if(paymentMethodId) {
            // Create a new PaymentIntent

            const params = {
                amount: orderAmount,
                confirm: true,
                confirmation_method: 'manual',
                currency: currency,
                payment_method: paymentMethodId,
                use_stripe_sdk: useStripeSdk
            }

            const intent = await stripe.paymentIntents.create(params);
            // console.log(intent);
            console.log(intent['client_secret']);
            for(var property in intent) { console.log(property + ": " + intent[property]) }
            return res.send(generateResponse(intent));
        }

        return res.sendStatus(400);
    } catch (e) {
        return res.send({error: e.message});
    }
});
exports.StripePayEndpointIntentId = functions.https.onRequest(async (req, res) => {
    const { paymentIntentId } = req.body;

    try {
        if(paymentIntentId) {
            const intent = await stripe.paymentIntents.confirm(paymentIntentId);
            return res.send(generateResponse(intent));
        }

        return res.sendStatus(400);

    } catch(e) {
        return res.send({error: e.message});
    }
});

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
