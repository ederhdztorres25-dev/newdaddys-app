import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newdaddys/theme/app_colors.dart';
import 'package:newdaddys/theme/app_fonts.dart';

// --- Modelo de Datos ---
class Message {
  final String text;
  final String time;
  final bool isSentByMe;

  Message({required this.text, required this.time, required this.isSentByMe});
}

// ─────────────────────────────────────────────────────────────────
// PANTALLA PRINCIPAL DE CHAT
// ─────────────────────────────────────────────────────────────────
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Lista de mensajes de ejemplo
  final List<Message> messages = [
    Message(text: 'Hola', time: '10:30', isSentByMe: false),
    Message(text: 'Hola', time: '10:34', isSentByMe: true),
    Message(text: '¿Cómo estás?', time: '10:30', isSentByMe: false),
  ];

  @override
  Widget build(BuildContext context) {
    // Funciones para medidas proporcionales
    final size = MediaQuery.of(context).size;
    double w(double px) => px * size.width / 1440;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _ChatAppBar(w: w),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: w(40), vertical: 20),
              itemCount: messages.length + 1, // +1 para el separador de fecha
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const _DateSeparator(date: 'Miercoles 20, 2024');
                }
                final message = messages[index - 1];
                return _MessageBubble(message: message, w: w);
              },
            ),
          ),
          _PremiumBanner(w: w),
        ],
      ),
      bottomNavigationBar: _MessageInputBar(w: w),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// WIDGETS PRIVADOS DE LA PANTALLA
// ─────────────────────────────────────────────────────────────────

// --- 1. AppBar Personalizada ---
class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppBar({required this.w});
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop()),
      title: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/karen.png'),
            radius: 20,
          ),
          SizedBox(width: w(30)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sofia Pedraza', style: AppFonts.h3),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: w(15)),
                  Text(
                    'En línea',
                    style: AppFonts.bodySmall.copyWith(color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// --- 2. Separador de Fecha ---
class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        date,
        style: AppFonts.bodySmall.copyWith(color: AppColors.placeholderText),
      ),
    );
  }
}

// --- 3. Burbuja de Mensaje ---
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.w});
  final Message message;
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isSentByMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: w(50), vertical: w(30)),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF7C3AED) : AppColors.primary,
          borderRadius: BorderRadius.circular(w(40)),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message.text, style: AppFonts.bodyMedium),
            const SizedBox(height: 5),
            Text(
              message.time,
              style: AppFonts.bodySmall
                  .copyWith(color: AppColors.placeholderText.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. Banner de Suscripción Premium ---
class _PremiumBanner extends StatelessWidget {
  const _PremiumBanner({required this.w});
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w(40), vertical: w(20)),
      padding: EdgeInsets.all(w(50)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(w(40)),
        gradient: const LinearGradient(
          colors: [Color(0xFFDA7806), Color(0xFFF49C0B)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invitaciones ilimitadas',
                    style: AppFonts.h3.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('Invita y conoce a todas las babys que quieras al mes',
                    style: AppFonts.bodySmall),
              ],
            ),
          ),
          SizedBox(width: w(30)),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(w(30)),
              ),
            ),
            child: const Text('Suscribirse'),
          ),
        ],
      ),
    );
  }
}

// --- 5. Barra de Entrada de Mensaje ---
class _MessageInputBar extends StatelessWidget {
  const _MessageInputBar({required this.w});
  final double Function(double) w;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w(40), vertical: w(20)),
      color: AppColors.backgroundColor,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: w(40)),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(w(40)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image_outlined,
                    color: AppColors.placeholderText),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  style: AppFonts.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje ...',
                    hintStyle: AppFonts.bodyMedium
                        .copyWith(color: AppColors.placeholderText),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.sentiment_satisfied_alt_outlined,
                    color: AppColors.placeholderText),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.placeholderText),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
