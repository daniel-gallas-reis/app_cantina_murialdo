const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

const pv = functions.config().rede.pv;
const token = functions.config().rede.token;

const eRede = require('./lib/erede');
const Transaction = require('./lib/transaction');
const Store = require('./lib/store');
const Environment = require('./lib/environment');
let transac;


exports.authorizeCreditCard = functions.https.onCall( async (data, context) => {
    if(data === null){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Dados não informados"
            }
        }
    }

    if(!context.auth){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Nenhum usuário logado"
            }
        }
    }

    const userId = context.auth.uid;
    const snapshot = await admin.firestore().collection("users").doc(userId).get();
    const userData = snapshot.data() || {};

    console.log("Iniciando autorização");

   
    let store = new Store(token, pv, Environment.sandbox());
    let transaction = await new Transaction(data.amount, data.reference).creditCard(
        data.creditCard.cardNumber,
        data.creditCard.securityCode,
        data.creditCard.expirationMonth,
        data.creditCard.expirationYear,
        data.creditCard.cardHolderName
    ).autoCapture(false);
    
//    const transaj;
//
//    await new eRede(store).create(transaction).then(transa => {
//        if (transa.returnCode === "00") {
//            console.log(`Transação autorizada com sucesso: ${transa.tid}`);
//            console.log(`Transação autorizada com sucesso: ${transa.returnMessage}`);
//            console.log(`Transação autorizada com sucesso: ${transac.amount}`);
//            return transaj.tid;
//        }else{
//            console.log(`Transação não autorizada: ${transac.returnCode}`);
//            return transa.returnCode;
//        }
//    }).catch(e => e);


//    return {
//        "result": transaj,
//    };

        try{
        transac = await new eRede(store).create(transaction);
        console.log(transac.returnCode);

        return {
            "returnCode": transac.returnCode,
            "tid": transac.tid,
            "authorizationCode": transac.authorizationCode,
            "amount": transac.amount
        };
    }catch(e){
        return {
            "returnCode": e.returnCode
        }
    }

});





exports.captureCreditCard = functions.https.onCall( async (data, context) => {
    if(data === null){
        console.log('deu null');
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Dados não informados"
            }
        }
    }

    if(!context.auth){
        console.log('nao tem user');
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Nenhum usuário logado"
            }
        }
    }

    console.log("inicio da captura");

    let store = new Store(token, pv, Environment.sandbox());
    let transaction = new Transaction(data.amount);
    //.creditCard(
    //    data.creditCard.cardNumber,
    //    data.creditCard.securityCode,
    //    data.creditCard.expirationMonth,
    //    data.creditCard.expirationYear,
    //   data.creditCard.cardHolderName
    //);
    let tid = {"tid": data.payId};

    //let tid = await new Transaction(data.amount, data.reference).fromJSON(transac);

    

    try{
        const captureParams = await new eRede(store).capture(tid);
        console.log(captureParams.returnCode);
        console.log(captureParams.returnMessage);

        return {
            "returnCode": captureParams.returnCode,
            "tid": captureParams.tid,
            "authorizationCode": captureParams.authorizationCode,
            "amount": captureParams.amount
        };
    }catch(e){
        return {
            "returnCode": e.returnCode,
            "tudo": e
        }
    }

});



exports.cancelCreditCard = functions.https.onCall( async (data, context) => {
    if(data === null){
        console.log('deu null');
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Dados não informados"
            }
        }
    }

    if(!context.auth){
        console.log('nao tem user');
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Nenhum usuário logado"
            }
        }
    }

    console.log("inicio da captura");

    let store = new Store(token, pv, Environment.sandbox());
    let transaction = new Transaction(data.amount);
    //.creditCard(
    //    data.creditCard.cardNumber,
    //    data.creditCard.securityCode,
    //    data.creditCard.expirationMonth,
    //    data.creditCard.expirationYear,
    //   data.creditCard.cardHolderName
    //);
    let tid = {"tid": data.payId};

    //let tid = await new Transaction(data.amount, data.reference).fromJSON(transac);

    

    try{
        const cancelParams = await new eRede(store).cancel(tid);
        console.log(cancelParams.returnCode);
        console.log(cancelParams.returnMessage);

        return {
            "returnCode": cancelParams.returnCode,
            "tid": cancelParams.tid,
            "authorizationCode": cancelParams.authorizationCode,
            "amount": cancelParams.amount
        };
    }catch(e){
        return {
            "returnCode": e.returnCode,
            "tudo": e
        }
    }

});





//
// exports.getUserData = functions.https.onCall( async (data, context) => {
//     if(!context.auth){
//         return {
//             "data": "Nenhum usuário logado!"
//         };
//     }
//
//     const snapshot = await admin.firestore().collection("users").doc(context.auth.uid).get();
//    return {
//         "data": snapshot.data()
//     };
// });
//
// exports.addMessage = functions.https.onCall( async (data, context) => {
//     console.log(data);

//     const snapshot = await admin.firestore().collection("messages").add(data);
//
//     return {"success": snapshot.id};
// });
//
 exports.onOrderStatusChanged = functions.firestore.document("/orders/{orderId}").onCreate( async (snapshot, context) => {
     const orderId = context.params.orderId;
     
     const querySnapshot = await admin.firestore().collection("admins").get();

     const admins = querySnapshot.docs.map(doc => doc.id);
     //console.log(admins);

     let adminsTokens = [];
     for(let i =0; i<admins.length; i++){
         //console.log(admins[i]);
         /* eslint-disable no-await-in-loop */
        const tokensAdmin = await getDeviceTokens(admins[i]);
        //console.log('tokensAdmins');
        //console.log(tokensAdmin);
        adminsTokens = adminsTokens.concat(tokensAdmin);
        //console.log('adminsTokens');
        //console.log(adminsTokens);
     }

    await sendPushFCM(
        adminsTokens,
        'Novo Pedido',
        'Nova venda Realizada. Pedido: ' + orderId
    );

 });

 

 exports.onNewOrder = functions.firestore.document("/orders/{orderId}").onUpdate( async (snapshot, context) => {
    const beforeStatus = snapshot.before.data().status;
    const afterStatus = snapshot.after.data().status;

    if(beforeStatus !== afterStatus){
        const tokensUser = await getDeviceTokens(snapshot.after.data().userId);
        await sendPushFCM(
            tokensUser,
            'Pedido: ' + context.params.orderId,
            'Status atualizado para: ' + orderStatus.get(afterStatus),
        );
    }

});

const orderStatus = new Map([
    [0, 'Cancelado'],
    [1, 'Preparando Pedido'],
    [2, 'Pedido em Transporte'],
    [3, 'Pedido Entregue']
]);
 
// exports.onOrderStatusChanged = functions.firestore.document("/orders/{orderId}").onUpdate( async (snapshot, context) => {
//    const beforeStatus = snapshot.before.data().status;
//    const afterStatus = snapshot.after.data().status;
//
//    if(beforeStatus !== afterStatus){
//        const tokensUser = await getDeviceTokens(snapshot.after.data().user);
//        console.log(tokensUser);
//        await sendPushFCM(
//            tokensUser,
//            'Pedido: ' + context.params.orderId,
//            'Status atualizado para: ' + orderStatus.get(afterStatus)
//        );
//        //console.log()
//    }
// });

 async function getDeviceTokens(uid){
     //console.log(uid);
    const querySnapshot = await admin.firestore().collection("users").doc(uid).collection("tokens").get();

    const tokens = querySnapshot.docs.map(doc => doc.id);
    //console.log('tokens');
    //console.log(tokens);
    return tokens;
 }

 async function sendPushFCM(tokens, title, message){
     if(tokens.length > 0){
        const payload = {
            notification: {
                title: title,
                body: message,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };
        return admin.messaging().sendToDevice(tokens, payload);
     }
    return;   
 }