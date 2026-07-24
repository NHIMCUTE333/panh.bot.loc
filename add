import React, { useState } from 'react';
import { X, Sparkles, Image as ImageIcon } from 'lucide-react';
import { CharacterCard } from '../types';

interface AddCardModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAddCard: (card: CharacterCard) => void;
}

const PRESET_IMAGES = [
  { name: 'Cổ trang nam', url: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=800' },
  { name: 'Hiện đại nam', url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=800' },
  { name: 'TXVT Sci-Fi', url: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=800' },
  { name: 'Ma Tôn', url: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&q=80&w=800' },
  { name: 'Thanh lịch', url: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=800' },
  { name: 'Học đường', url: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=800' },
];

export const AddCardModal: React.FC<AddCardModalProps> = ({
  isOpen,
  onClose,
  onAddCard,
}) => {
  const [name, setName] = useState('');
  const [tag, setTag] = useState<string>('Cổ trang');
  const [imageUrl, setImageUrl] = useState(PRESET_IMAGES[0].url);
  const [chatUrl, setChatUrl] = useState('');
  const [copyLink, setCopyLink] = useState('');
  const [author, setAuthor] = useState('');
  const [description, setDescription] = useState('');
  const [greeting, setGreeting] = useState('');

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;

    const newCard: CharacterCard = {
      id: `bot-${Date.now()}`,
      name: name.trim(),
      tag,
      imageUrl: imageUrl.trim() || PRESET_IMAGES[0].url,
      chatUrl: chatUrl.trim() || 'https://c.ai',
      copyLink: copyLink.trim() || chatUrl.trim() || 'https://c.ai',
      author: author.trim() || 'Ẩn danh',
      description: description.trim(),
      greeting: greeting.trim() || `Xin chào! Tôi là ${name.trim()}.`,
      likesCount: 0,
      isFavorite: false,
      createdAt: new Date().toISOString().split('T')[0],
    };

    onAddCard(newCard);
    // Reset form
    setName('');
    setDescription('');
    setChatUrl('');
    setCopyLink('');
    setGreeting('');
    onClose();
  };

  return (
    <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in duration-200">
      <div className="bg-[#FFFDF0] w-full max-w-lg rounded-2xl overflow-hidden shadow-2xl border border-[#D4A373]/30 flex flex-col max-h-[90vh]">
        {/* Header */}
        <div className="px-6 py-4 bg-[#FFF9E6] border-b border-[#D4A373]/20 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Sparkles className="w-4 h-4 text-[#D4A373]" />
            <h2 className="font-serif text-xl font-semibold text-[#D4A373]">Thêm Nhân Vật Mới</h2>
          </div>
          <button
            onClick={onClose}
            className="p-1 rounded-full text-gray-500 hover:text-gray-800 hover:bg-amber-200/50 transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Form Body */}
        <form onSubmit={handleSubmit} className="p-6 overflow-y-auto space-y-4">
          <div>
            <label className="block text-[10px] font-bold text-[#D4A373] uppercase tracking-widest mb-1">
              Tên nhân vật / Bot *
            </label>
            <input
              type="text"
              required
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="VD: Bắc Minh Dạ..."
              className="w-full px-4 py-2.5 rounded-xl border border-[#D4A373]/30 bg-white text-xs sm:text-sm outline-none focus:ring-1 focus:ring-[#D4A373]"
            />
          </div>

          <div>
            <label className="block text-[10px] font-bold text-[#D4A373] uppercase tracking-widest mb-1">
              Thể loại / Tag
            </label>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
              {(['Cổ trang', 'Hiện đại', 'TXVT', 'Huyền huyễn', 'Ngược', 'BL', 'Showbiz'] as const).map((t) => (
                <button
                  key={t}
                  type="button"
                  onClick={() => setTag(t)}
                  className={`py-2 px-3 rounded-xl text-xs font-semibold border transition-all cursor-pointer ${
                    tag === t
                      ? 'bg-[#FFFDF0] text-[#D4A373] border-[#D4A373] font-bold shadow-2xs'
                      : 'bg-white text-gray-600 border-gray-200 hover:border-[#D4A373]/30'
                  }`}
                >
                  {t}
                </button>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-[10px] font-bold text-[#D4A373] uppercase tracking-widest mb-1">
              Ảnh đại diện (Chọn mẫu hoặc nhập link)
            </label>
            <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-none">
              {PRESET_IMAGES.map((img, idx) => (
                <button
                  key={idx}
                  type="button"
                  onClick={() => setImageUrl(img.url)}
                  className={`relative flex-shrink-0 w-16 h-16 rounded-xl overflow-hidden border-2 transition-all cursor-pointer ${
                    imageUrl === img.url ? 'border-[#D4A373] ring-2 ring-amber-200 scale-105' : 'border-gray-200 opacity-70 hover:opacity-100'
                  }`}
                >
                  <img src={img.url} alt={img.name} className="w-full h-full object-cover" />
                </button>
              ))}
            </div>
            <div className="relative mt-1">
              <input
                type="url"
                value={imageUrl}
                onChange={(e) => setImageUrl(e.target.value)}
                placeholder="https://..."
                className="w-full pl-9 pr-4 py-2 rounded-xl border border-[#D4A373]/30 bg-white text-xs outline-none focus:ring-1 focus:ring-[#D4A373]"
              />
              <ImageIcon className="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-[10px] font-bold text-[#D4A373] uppercase tracking-widest mb-1">
                Tác giả / Nguồn
              </label>
              <input
                type="text"
                value={author}
                onChange={(e) => setAuthor(e.target.value)}
                placeholder="VD: Tuyết Hoa..."
                className="w-full px-4 py-2 rounded-xl border border-[#D4A373]/30 bg-white text-xs outline-none focus:ring-1 focus:ring-[#D4A373]"
              />
            </div>
            <div>
              <label className="block text-[10px] font-bold text-[#D4A373] uppercase tracking-widest mb-1">
                Link trò chuyện (Chat URL)
              </label>
              <input
                type="url"
                value={chatUrl}
                onChange={(e) => setChatUrl(e.target.value)}
                placeholder="https://c.ai/..."
                className="w-full px-4 py-2 rounded-xl border border-[#D4A373]/30 bg-white text-xs outline-none focus:ring-1 focus:ring-[#D4A373]"
              />
            </div>
          </div>

          <div>
            <label className="block text-[10px] font-bold text-[#D4A373] uppercase tracking-widest mb-1">
              Link chia sẻ (Copy Link)
            </label>
            <input
              type="url"
              value={copyLink}
              onChange={(e) => setCopyLink(e.target.value)}
              placeholder="Để trống nếu giống Chat URL"
              className="w-full px-4 py-2 rounded-xl border border-[#D4A373]/30 bg-white text-xs outline-none focus:ring-1 focus:ring-[#D4A373]"
            />
          </div>

          <div>
            <label className="block text-[10px] font-bold text-[#D4A373] uppercase tracking-widest mb-1">
              Lời chào khởi đầu (Dùng cho bản dùng thử)
            </label>
            <input
              type="text"
              value={greeting}
              onChange={(e) => setGreeting(e.target.value)}
              placeholder="VD: Nàng đã đến rồi sao? Lại đây..."
              className="w-full px-4 py-2 rounded-xl border border-[#D4A373]/30 bg-white text-xs outline-none focus:ring-1 focus:ring-[#D4A373]"
            />
          </div>

          <div>
            <label className="block text-[10px] font-bold text-[#D4A373] uppercase tracking-widest mb-1">
              Mô tả ngắn về nhân vật
            </label>
            <textarea
              rows={2}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Tính cách, xuất thân hoặc câu chuyện ngắn..."
              className="w-full px-4 py-2 rounded-xl border border-[#D4A373]/30 bg-white text-xs outline-none focus:ring-1 focus:ring-[#D4A373]"
            />
          </div>

          {/* Submit */}
          <div className="pt-2 flex items-center justify-end gap-2">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 rounded-full text-xs font-bold uppercase tracking-wider text-gray-600 bg-gray-100 hover:bg-gray-200 transition-colors cursor-pointer"
            >
              Hủy
            </button>
            <button
              type="submit"
              className="px-6 py-2.5 rounded-full text-xs font-bold uppercase tracking-wider text-white bg-[#D4A373] hover:bg-[#b08256] shadow-2xs transition-all active:scale-95 cursor-pointer"
            >
              Thêm nhân vật
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
