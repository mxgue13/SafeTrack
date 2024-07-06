package com.ejemplo.safetrack;

import android.util.Log;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

public class MyFirebaseMessagingService extends FirebaseMessagingService {
    private static final String TAG = "MyFirebaseMsgService";

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        // Maneja la recepción de mensajes aquí
        Log.d(TAG, "From: " + remoteMessage.getFrom());

        // Comprueba si el mensaje contiene una notificación
        if (remoteMessage.getNotification() != null) {
            Log.d(TAG, "Notificación recibida: " + remoteMessage.getNotification().getBody());

            // Aquí puedes manejar cómo deseas mostrar la notificación al usuario
            // Por ejemplo, mostrarla en la barra de notificaciones
            String title = remoteMessage.getNotification().getTitle();
            String body = remoteMessage.getNotification().getBody();
            // Ejemplo: mostrar la notificación en la barra de notificaciones
            // o enviar una notificación local personalizada
        }

        // Comprueba si el mensaje contiene datos
        if (remoteMessage.getData().size() > 0) {
            Log.d(TAG, "Datos del mensaje: " + remoteMessage.getData());
            // Aquí puedes manejar los datos adicionales del mensaje, si los hay
        }
    }

    @Override
    public void onNewToken(String token) {
        Log.d(TAG, "Nuevo token FCM: " + token);
        // Aquí puedes manejar el nuevo token generado por Firebase
        // Por ejemplo, enviar este token al servidor de backend para enviar notificaciones push
    }
}
