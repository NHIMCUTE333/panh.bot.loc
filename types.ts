export type CategoryTag = 'Tất cả' | 'Cổ trang' | 'Hiện đại' | string;

export interface CharacterCard {
  id: string;
  name: string;
  tag: 'Hiện đại' | 'Cổ trang' | string;
  tagsList?: string[];
  imageUrl: string;
  imagesList?: string[];
  chatUrl: string;
  copyLink?: string;
  description?: string;
  author?: string;
  greeting?: string;
  personality?: string;
  likesCount?: number;
  isFavorite?: boolean;
  createdAt: string;
}

export interface ChatMessage {
  id: string;
  sender: 'user' | 'bot';
  text: string;
  timestamp: string;
}
