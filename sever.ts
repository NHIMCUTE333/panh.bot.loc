import express from 'express';
import path from 'path';
import { createServer as createViteServer } from 'vite';
import { GoogleGenAI } from '@google/genai';

const app = express();
const PORT = 3000;

app.use(express.json());

// API endpoint for character chat simulation
app.post('/api/chat', async (req, res) => {
  try {
    const { characterName, characterTag, description, personality, greeting, userMessage, history } = req.body;

    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      return res.json({ reply: null, note: 'No API key provided' });
    }

    const ai = new GoogleGenAI({ apiKey });

    const systemInstruction = `
      Bạn là nhân vật "${characterName}" trong thể loại "${characterTag}".
      Mô tả nhân vật: ${description || 'Một nhân vật hấp dẫn, thâm tình'}.
      Tính cách: ${personality || 'Ấm áp, tinh tế, ngọt ngào'}.
      Lời chào ban đầu: "${greeting || ''}".

      HÃY VÀO VAI NHÂN VẬT NÀY VÀ TRẢ LỜI BẰNG TIẾNG VIỆT CỰC KỲ TỰ NHIÊN, NGỌT NGÀO, ĐÚNG PHONG CÁCH CỦA MỘT CHỒNG/BẠN TRAI/NHÂN VẬT AI TRONG WEB-NOVEL.
      - Trả lời ngắn gọn (1-3 câu), thân mật, thu hút.
      - Xưng hô phù hợp với thể loại (Thị xưng nàng/ta với Cổ trang, anh/em với Hiện đại, v.v.).
    `;

    const promptMessages = [];
    if (history && Array.isArray(history)) {
      for (const msg of history) {
        promptMessages.push(`${msg.role === 'user' ? 'User' : characterName}: ${msg.content}`);
      }
    }
    promptMessages.push(`User: ${userMessage}`);

    const fullPrompt = `${systemInstruction}\n\nCuộc trò chuyện:\n${promptMessages.join('\n')}\n${characterName}:`;

    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: fullPrompt,
    });

    const reply = response.text?.trim() || 'Anh vẫn luôn lắng nghe em đây...';
    return res.json({ reply });
  } catch (err: any) {
    console.error('Gemini API Chat Error:', err?.message || err);
    return res.json({ reply: null });
  }
});

async function startServer() {
  // Vite middleware for development vs production static serve
  if (process.env.NODE_ENV !== 'production') {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: 'spa',
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), 'dist');
    app.use(express.static(distPath));
    app.get('*', (req, res) => {
      res.sendFile(path.join(distPath, 'index.html'));
    });
  }

  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Bánh Bột Lọc server running on http://0.0.0.0:${PORT}`);
  });
}
