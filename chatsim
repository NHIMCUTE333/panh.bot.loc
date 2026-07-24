import React, { useState, useEffect, useRef } from 'react';
import { X, Send, Sparkles, RefreshCw, ExternalLink } from 'lucide-react';
import { CharacterCard, ChatMessage } from '../types';

interface ChatSimulatorModalProps {
  card: CharacterCard | null;
  isOpen: boolean;
  onClose: () => void;
}

export const ChatSimulatorModal: React.FC<ChatSimulatorModalProps> = ({
  card,
  isOpen,
  onClose,
}) => {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (card && isOpen) {
      // Initialize with character's greeting
      const initialGreeting = card.greeting || `Xin chào! Ta là ${card.name}. Rất vui vì nàng đã ghé thăm.`;
      setMessages([
        {
          id: 'msg-0',
          sender: 'bot',
          text: initialGreeting,
          timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        },
      ]);
    }
  }, [card, isOpen]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, isTyping]);

  if (!isOpen || !card) return null;

  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() || isTyping) return;

    const userMsgText = input.trim();
    const userMsg: ChatMessage = {
      id: `msg-${Date.now()}`,
      sender: 'user',
      text: userMsgText,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    };

    setMessages((prev) => [...prev, userMsg]);
    setInput('');
    setIsTyping(true);

    try {
      // Try calling server api for character AI roleplay
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          characterName: card.name,
          characterTag: card.tag,
          description: card.description,
          personality: card.personality,
          greeting: card.greeting,
          userMessage: userMsgText,
          history: messages.slice(-6).map((m) => ({ role: m.sender, content: m.text })),
        }),
      });

      if (response.ok) {
        const data = await response.json();
        if (data.reply) {
          setMessages((prev) => [
            ...prev,
            {
              id: `msg-${Date.now()}`,
              sender: 'bot',
              text: data.reply,
              timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
            },
          ]);
          setIsTyping(false);
          return;
        }
      }
    } catch (err) {
      console.log('API roleplay fallback active');
    }

    // Gentle fallback roleplay generator based on character tag & name
    setTimeout(() => {
      let botReply = '';
      if (card.tag === 'Cổ trang') {
        const ancientReplies = [
          `Nàng vừa nói gì cơ? Lại đây gần hơn nữa, ta nghe chưa rõ.`,
          `Thiên hạ này lắm thị phi, nhưng ở bên nàng, lòng ta mới thực sự bình yên.`,
          `Lời nàng nói làm lòng ta xao xuyến. Nàng muốn đi dạo cùng ta tối nay không?`,
          `Có đôi lúc ta tự hỏi, phải duyên kiếp từ bao giờ mà gặp được nàng.`
        ];
        botReply = ancientReplies[Math.floor(Math.random() * ancientReplies.length)];
      } else if (card.tag === 'Hiện đại') {
        const modernReplies = [
          `Anh nghe đây. Hôm nay ở trường / công ty có chuyện gì vui kể anh nghe xem?`,
          `Em nói thế làm anh tò mò rồi đấy. Muốn ăn gì không anh gọi giao tới ngay?`,
          `Đừng suy nghĩ nhiều quá. Có anh ở đây rồi, mọi chuyện cứ để anh lo.`,
          `Nhớ em quá. Cuối tuần này mình hẹn hò nhé?`
        ];
        botReply = modernReplies[Math.floor(Math.random() * modernReplies.length)];
      } else {
        const genericReplies = [
          `Ý kiến của bạn rất thú vị! Hãy tiếp tục trò chuyện cùng ${card.name} nhé.`,
          `Nhịp tim cảm ứng phát hiện tín hiệu rất ngọt ngào từ câu nói vừa rồi!`,
          `Ta nghe câu trả lời này và càng muốn khám phá thêm về em đấy.`
        ];
        botReply = genericReplies[Math.floor(Math.random() * genericReplies.length)];
      }

      setMessages((prev) => [
        ...prev,
        {
          id: `msg-${Date.now()}`,
          sender: 'bot',
          text: botReply,
          timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        },
      ]);
      setIsTyping(false);
    }, 900);
  };

  const handleReset = () => {
    const initialGreeting = card.greeting || `Xin chào! Ta là ${card.name}.`;
    setMessages([
      {
        id: `msg-${Date.now()}`,
        sender: 'bot',
        text: initialGreeting,
        timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      },
    ]);
  };

  return (
    <div className="fixed inset-0 z-[9999] flex items-center justify-center p-3 sm:p-4 bg-black/60 backdrop-blur-xs animate-in fade-in duration-200">
      <div className="bg-[#FFFDF0] w-full max-w-md h-[85vh] rounded-2xl overflow-hidden shadow-2xl border border-[#D4A373]/30 flex flex-col relative">
        {/* Header */}
        <div className="px-4 py-3 bg-[#FFF9E6] border-b border-[#D4A373]/20 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full overflow-hidden border border-[#D4A373]/40">
              <img src={card.imageUrl} alt={card.name} className="w-full h-full object-cover" />
            </div>
            <div>
              <h3 className="font-serif text-lg font-semibold text-gray-800 flex items-center gap-1.5 leading-tight">
                {card.name}
                <span className="text-[9px] px-2 py-0.5 uppercase tracking-widest bg-white border border-[#D4A373]/30 text-[#D4A373] font-bold">
                  {card.tag}
                </span>
              </h3>
              <p className="text-[10px] text-[#A3B18A] uppercase tracking-wider font-semibold">Live AI Roleplay Demo</p>
            </div>
          </div>

          <div className="flex items-center gap-1">
            <button
              onClick={handleReset}
              className="p-1.5 rounded-full text-[#D4A373] hover:bg-[#D4A373]/15 transition-colors cursor-pointer"
              title="Trò chuyện lại từ đầu"
            >
              <RefreshCw className="w-4 h-4" />
            </button>
            <a
              href={card.chatUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="p-1.5 rounded-full text-[#D4A373] hover:bg-[#D4A373]/15 transition-colors cursor-pointer"
              title="Mở Chat Web gốc"
            >
              <ExternalLink className="w-4 h-4" />
            </a>
            <button
              onClick={onClose}
              className="p-1.5 rounded-full text-gray-600 hover:bg-[#D4A373]/15 transition-colors cursor-pointer"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Message List */}
        <div className="flex-1 p-4 overflow-y-auto space-y-3 bg-[#FFFDF0]">
          {messages.map((msg) => (
            <div
              key={msg.id}
              className={`flex gap-2 ${msg.sender === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              {msg.sender === 'bot' && (
                <div className="w-7 h-7 rounded-full overflow-hidden border border-[#D4A373]/30 flex-shrink-0 mt-1">
                  <img src={card.imageUrl} alt={card.name} className="w-full h-full object-cover" />
                </div>
              )}

              <div
                className={`max-w-[80%] px-4 py-2.5 rounded-2xl text-xs sm:text-sm font-normal leading-relaxed shadow-2xs ${
                  msg.sender === 'user'
                    ? 'bg-[#D4A373] text-white rounded-tr-none'
                    : 'bg-white border border-[#D4A373]/20 text-gray-800 rounded-tl-none font-serif'
                }`}
              >
                <p>{msg.text}</p>
                <span
                  className={`block text-[9px] mt-1 text-right ${
                    msg.sender === 'user' ? 'text-amber-100' : 'text-gray-400 font-sans'
                  }`}
                >
                  {msg.timestamp}
                </span>
              </div>
            </div>
          ))}

          {isTyping && (
            <div className="flex gap-2 justify-start items-center">
              <div className="w-7 h-7 rounded-full overflow-hidden border border-[#D4A373]/30 flex-shrink-0">
                <img src={card.imageUrl} alt={card.name} className="w-full h-full object-cover" />
              </div>
              <div className="bg-white border border-[#D4A373]/20 px-4 py-2 rounded-2xl rounded-tl-none text-xs text-gray-500 italic flex items-center gap-1.5 font-serif">
                <Sparkles className="w-3.5 h-3.5 text-[#D4A373] animate-spin" />
                {card.name} đang suy nghĩ...
              </div>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>

        {/* Footer Input */}
        <form onSubmit={handleSendMessage} className="p-3 bg-white border-t border-[#D4A373]/20 flex items-center gap-2">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder={`Trò chuyện với ${card.name}...`}
            className="flex-1 px-4 py-2.5 rounded-full border border-[#D4A373]/30 bg-[#FFFDF0] text-xs sm:text-sm outline-none focus:ring-1 focus:ring-[#D4A373] text-gray-800"
          />
          <button
            type="submit"
            disabled={!input.trim() || isTyping}
            className="p-2.5 rounded-full bg-[#D4A373] text-white hover:bg-[#b08256] disabled:opacity-50 transition-all cursor-pointer flex-shrink-0 shadow-2xs"
          >
            <Send className="w-4 h-4" />
          </button>
        </form>
      </div>
    </div>
  );
};
