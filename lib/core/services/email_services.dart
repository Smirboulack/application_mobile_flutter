import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static Future<void> sendHtmlEmail({
    required String recipient,
    required String subject,
    required String htmlBody,
  }) async {

    print("heeeere");
    final smtpServer = SmtpServer(
      'smtp.ionos.fr',
      username: 'contact@sevenjobs.fr', // Your email address
      password: "CSEVENJOBS6969",   // Your email password
      port: 465,
      ssl: true,
    );

    final message = Message()
      ..from = Address('contact@sevenjobs.fr')
    // Your email address
      ..recipients.add(recipient) // Recipient's email address
      ..subject = subject
      ..html = htmlBody; // Use html instead of text for HTML content

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
