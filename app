import React, { useState, useEffect } from 'react';
import { WelcomePage } from './components/WelcomePage';
import { SearchBar } from './components/SearchBar';
import { MusicPlayer } from './components/MusicPlayer';
import { ItemCard } from './components/ItemCard';
import { Toast } from './components/Toast';
import { AddCardModal } from './components/AddCardModal';
import { ChatSimulatorModal } from './components/ChatSimulatorModal';
import { DetailModal } from './components/DetailModal';
import { FeedbackModal } from './components/FeedbackModal';
import { INITIAL_CARDS } from './data/initialCards';
import { CharacterCard, CategoryTag } from './types';
import { Heart, Home, Sparkles, Plus, Layers, Grid, Compass, Bookmark, ShieldCheck } from 'lucide-react';

const STORAGE_KEY = 'banh_bot_loc_cards_v12';

export default function App() {
  const [showWelcome, setShowWelcome] = useState<boolean>(true);
  const [cards, setCards] = useState<CharacterCard[]>(() => {
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) {
        return JSON.parse(saved);
      }
    } catch (e) {
      console.error('Error loading cards from localStorage', e);
    }
    return INITIAL_CARDS;
  });

  const [searchTerm, setSearchTerm] = useState('');
  const [selectedTag, setSelectedTag] = useState<CategoryTag>('Tất cả');
  const [showFavoritesOnly, setShowFavoritesOnly] = useState(false);

  // Modals
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [isFeedbackOpen, setIsFeedbackOpen] = useState(false);
  const [selectedDetailCard, setSelectedDetailCard] = useState<CharacterCard | null>(null);
  const [selectedChatCard, setSelectedChatCard] = useState<CharacterCard | null>(null);

  // Toast
  const [toastMessage, setToastMessage] = useState('Đã copy đường link!');
  const [showToast, setShowToast] = useState(false);

  // Save to localStorage on change
  useEffect(() => {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(cards));
    } catch (e) {
      console.error('Error saving cards to localStorage', e);
    }
  }, [cards]);

  const triggerToast = (msg: string) => {
    setToastMessage(msg);
    setShowToast(true);
    setTimeout(() => {
      setShowToast(false);
    }, 2200);
  };

  const handleEnterShop = () => {
    setShowWelcome(false);
  };

  const handleCopyToClipboard = (link: string) => {
    navigator.clipboard
      .writeText(link)
      .then(() => {
        triggerToast('Đã copy đường link!');
      })
      .catch((err) => {
        console.error('Lỗi copy: ', err);
        triggerToast('Đã sao chép liên kết!');
      });
  };

  const handleToggleFavorite = (id: string) => {
    setCards((prev) =>
      prev.map((c) => {
        if (c.id === id) {
          const updated = !c.isFavorite;
          triggerToast(updated ? 'Đã thêm vào Yêu thích ❤️' : 'Đã bỏ Yêu thích');
          return { ...c, isFavorite: updated };
        }
        return c;
      })
    );
  };

  const handleAddCard = (newCard: CharacterCard) => {
    setCards((prev) => [newCard, ...prev]);
    triggerToast('Thêm nhân vật mới thành công! ✨');
  };

  // Filter Cards
  const filteredCards = cards.filter((card) => {
    if (showFavoritesOnly && !card.isFavorite) {
      return false;
    }

    if (selectedTag !== 'Tất cả') {
      const matchPrimary = card.tag === selectedTag;
      const matchTagsList = card.tagsList?.some(t => t.toLowerCase() === selectedTag.toLowerCase()) || false;
      const matchPersonality = card.personality?.toLowerCase().includes(selectedTag.toLowerCase()) || false;
      const matchDesc = card.description?.toLowerCase().includes(selectedTag.toLowerCase()) || false;
      if (!matchPrimary && !matchTagsList && !matchPersonality && !matchDesc) {
        return false;
      }
    }

    if (searchTerm.trim()) {
      const q = searchTerm.toLowerCase();
      const matchName = card.name.toLowerCase().includes(q);
      const matchDesc = card.description?.toLowerCase().includes(q) || false;
      const matchAuthor = card.author?.toLowerCase().includes(q) || false;
      const matchTag = card.tag.toLowerCase().includes(q);
      return matchName || matchDesc || matchAuthor || matchTag;
    }

    return true;
  });

  const favoriteCount = cards.filter((c) => c.isFavorite).length;

  return (
    <div className="min-h-screen text-[#4A4A4A] relative selection:bg-[#D4A373]/20 selection:text-[#D4A373] bg-neutral-900">
      {/* Background Image for Main App Page with 60% Dark Overlay */}
      <div className="fixed inset-0 w-full h-full z-0 pointer-events-none overflow-hidden">
        <img
          src="https://i.pinimg.com/control1/1200x/a9/bf/42/a9bf427fd42bd3b27ffa421470e3c098.jpg"
          alt="Main Background"
          className="w-full h-full object-cover object-center scale-105"
          onError={(e) => {
            (e.target as HTMLImageElement).src = 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=1600';
          }}
        />
        {/* 60% Dark Overlay */}
        <div className="absolute inset-0 bg-black/60 backdrop-brightness-95" />
      </div>

      {/* 1. TRANG BƯỚC VÀO (WELCOME PAGE) */}
      {showWelcome && <WelcomePage onEnter={handleEnterShop} />}

      {/* 2. MAIN APPLICATION CONTAINER */}
      <div id="main-page" className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 md:py-6 transition-opacity duration-500">
        
        {/* COLLAPSIBLE MUSIC PLAYER AT TOP */}
        <div className="mb-4">
          <MusicPlayer isWelcomePage={showWelcome} />
        </div>

        {/* GEOMETRIC BALANCE MAIN GRID (SIDEBAR + CONTENT) */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          
          {/* LEFT SIDEBAR PANEL (Desktop layout enhancement) */}
          <aside className="hidden lg:block lg:col-span-3 space-y-6 sticky top-6">
            {/* Boutique Header Widget */}
            <div className="p-6 rounded-2xl bg-white/92 border border-[#D4A373]/40 shadow-xl backdrop-blur-md text-center relative overflow-hidden">
              <div className="absolute top-0 left-0 right-0 h-1 bg-[#D4A373]" />
              
              <div className="w-14 h-14 mx-auto mb-3 border border-[#D4A373]/40 rotate-45 flex items-center justify-center bg-[#FFFDF0] shadow-sm">
                <Sparkles className="w-6 h-6 text-[#D4A373] -rotate-45" />
              </div>

              <h2 className="font-serif text-2xl font-semibold text-[#D4A373] tracking-tight">
                Bánh Bột Lọc
              </h2>
              <p className="text-[10px] tracking-[0.25em] font-bold text-[#6B8E23] uppercase mt-1">
                GEOMETRIC BOUTIQUE
              </p>

              <div className="my-4 border-t border-[#D4A373]/20" />

              <div className="space-y-2 text-xs text-gray-700 text-left">
                <div className="flex items-center justify-between">
                  <span className="text-gray-500 font-medium">Tổng nhân vật:</span>
                  <span className="font-bold text-[#D4A373]">{cards.length}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-gray-500 font-medium">Đã yêu thích:</span>
                  <span className="font-bold text-[#C2185B]">{favoriteCount}</span>
                </div>
              </div>

              <button
                onClick={() => setShowWelcome(true)}
                className="mt-5 w-full py-2.5 px-3 rounded-full border border-[#D4A373]/60 text-[#D4A373] hover:bg-[#D4A373] hover:text-white bg-white/80 text-xs font-bold uppercase tracking-wider transition-all flex items-center justify-center gap-1.5 cursor-pointer shadow-2xs"
              >
                <Home className="w-3.5 h-3.5" />
                Về màn hình chào
              </button>
            </div>

            {/* Quick Filter Widget */}
            <div className="p-5 rounded-2xl bg-white/92 border border-[#D4A373]/40 shadow-xl backdrop-blur-md space-y-3">
              <h3 className="text-[10px] font-bold text-[#D4A373] uppercase tracking-widest flex items-center gap-1.5">
                <Compass className="w-3.5 h-3.5 text-[#D4A373]" /> Điều hướng nhanh
              </h3>

              <div className="space-y-1.5">
                <button
                  onClick={() => {
                    setShowFavoritesOnly(false);
                    setSelectedTag('Tất cả');
                  }}
                  className={`w-full text-left px-3.5 py-2.5 rounded-2xl text-xs font-medium flex items-center justify-between cursor-pointer transition-all ${
                    selectedTag === 'Tất cả' && !showFavoritesOnly
                      ? 'bg-[#D4A373] text-white font-bold shadow-sm'
                      : 'text-gray-700 bg-gray-50/80 hover:bg-gray-100 border border-gray-200/60'
                  }`}
                >
                  <span className="flex items-center gap-2">
                    <Grid className="w-3.5 h-3.5" /> Tất cả bộ sưu tập
                  </span>
                  <span className="text-[10px] bg-white/90 text-gray-800 px-2 py-0.5 rounded-full font-bold shadow-2xs">{cards.length}</span>
                </button>

                <button
                  onClick={() => setShowFavoritesOnly(true)}
                  className={`w-full text-left px-3.5 py-2.5 rounded-2xl text-xs font-medium flex items-center justify-between cursor-pointer transition-all ${
                    showFavoritesOnly
                      ? 'bg-[#C2185B] text-white font-bold shadow-sm'
                      : 'text-gray-700 bg-pink-50/70 hover:bg-pink-100/80 border border-pink-200/60'
                  }`}
                >
                  <span className="flex items-center gap-2">
                    <Bookmark className="w-3.5 h-3.5 text-[#C2185B]" /> Danh sách yêu thích
                  </span>
                  <span className="text-[10px] bg-pink-100 text-[#C2185B] px-2 py-0.5 rounded-full font-bold">
                    {favoriteCount}
                  </span>
                </button>
              </div>
            </div>
          </aside>

          {/* MAIN CONTENT AREA */}
          <main className="lg:col-span-9 max-w-2xl lg:max-w-none mx-auto w-full">
            {/* Search & Header Navigation */}
            <SearchBar
              searchTerm={searchTerm}
              setSearchTerm={setSearchTerm}
              selectedTag={selectedTag}
              setSelectedTag={setSelectedTag}
              showFavoritesOnly={showFavoritesOnly}
              setShowFavoritesOnly={setShowFavoritesOnly}
              onGoWelcome={() => setShowWelcome(true)}
              onOpenFeedback={() => setIsFeedbackOpen(true)}
              totalCards={cards.length}
              favoriteCount={favoriteCount}
            />

            {/* List Filter Indicator Header */}
            <div className="flex items-center justify-between mb-5 px-4 py-2.5 bg-white/90 backdrop-blur-md rounded-2xl border border-[#D4A373]/30 shadow-md">
              <p className="text-xs font-semibold text-gray-700 flex items-center gap-1.5">
                <Layers className="w-3.5 h-3.5 text-[#D4A373]" />
                {showFavoritesOnly ? (
                  <span>Danh sách Yêu thích ({filteredCards.length})</span>
                ) : (
                  <span>
                    Danh mục: <span className="text-[#B37840] font-bold">{selectedTag}</span> ({filteredCards.length})
                  </span>
                )}
              </p>

              <button
                onClick={() => setShowWelcome(true)}
                className="lg:hidden text-[11px] font-semibold text-[#6B8E23] hover:text-[#D4A373] flex items-center gap-1 bg-white/90 px-3 py-1 rounded-full border border-[#D4A373]/30 transition-colors cursor-pointer shadow-2xs"
              >
                <Home className="w-3 h-3" />
                Màn hình chào
              </button>
            </div>

            {/* Grid / List of Items */}
            {filteredCards.length > 0 ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 xl:grid-cols-2 gap-6">
                {filteredCards.map((card) => (
                  <ItemCard
                    key={card.id}
                    card={card}
                    onCopyLink={handleCopyToClipboard}
                    onToggleFavorite={handleToggleFavorite}
                    onOpenDetail={(c) => setSelectedDetailCard(c)}
                    onOpenChatSimulator={(c) => setSelectedChatCard(c)}
                  />
                ))}
              </div>
            ) : (
              <div className="bg-white rounded-2xl p-10 text-center border border-[#D4A373]/30 my-6 shadow-2xs">
                <div className="w-14 h-14 rounded-full bg-[#FFFDF0] border border-[#D4A373]/40 mx-auto flex items-center justify-center mb-3">
                  <Sparkles className="w-6 h-6 text-[#D4A373]" />
                </div>
                <h3 className="font-serif text-lg font-semibold text-gray-800 mb-1">Chưa tìm thấy nhân vật phù hợp</h3>
                <p className="text-xs text-gray-500 mb-5 max-w-sm mx-auto">
                  Thử tìm kiếm với từ khóa khác hoặc nhấn "Thêm mới" để catalog mẫu nhân vật bạn thích.
                </p>
                <button
                  onClick={() => {
                    setSearchTerm('');
                    setSelectedTag('Tất cả');
                    setShowFavoritesOnly(false);
                  }}
                  className="px-5 py-2 rounded-full bg-[#FFFDF0] text-[#D4A373] border border-[#D4A373] text-xs font-bold uppercase tracking-wider hover:bg-[#D4A373] hover:text-white transition-all cursor-pointer shadow-2xs"
                >
                  Xóa bộ lọc
                </button>
              </div>
            )}

            {/* Footer */}
            <footer className="mt-12 pt-6 border-t border-[#D4A373]/20 text-center text-xs text-[#A3B18A] space-y-1 pb-8">
              <p className="font-semibold text-amber-100/90 drop-shadow-xs">Bánh Bột Lọc • Weo com đến với Bột</p>
              <p className="text-[10px] tracking-wider uppercase text-amber-200/80">Bấm "Copy link" hoặc "Mở Chat" để bắt đầu trò chuyện</p>
            </footer>
          </main>
        </div>
      </div>

      {/* Modals & Toast */}
      <Toast message={toastMessage} isVisible={showToast} />

      <AddCardModal
        isOpen={isAddModalOpen}
        onClose={() => setIsAddModalOpen(false)}
        onAddCard={handleAddCard}
      />

      <DetailModal
        card={selectedDetailCard}
        isOpen={!!selectedDetailCard}
        onClose={() => setSelectedDetailCard(null)}
        onCopyLink={handleCopyToClipboard}
        onToggleFavorite={handleToggleFavorite}
        onOpenChatSimulator={(c) => setSelectedChatCard(c)}
      />

      <ChatSimulatorModal
        card={selectedChatCard}
        isOpen={!!selectedChatCard}
        onClose={() => setSelectedChatCard(null)}
      />

      <FeedbackModal
        isOpen={isFeedbackOpen}
        onClose={() => setIsFeedbackOpen(false)}
      />
    </div>
  );
}
