
CREATE DATABASE IF NOT EXISTS ecommerce
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce;

-- Nettoyage (supprime les anciennes versions des tables)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
--  Table users : les comptes (clients et administrateurs)
-- ------------------------------------------------------------
CREATE TABLE users (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  name     VARCHAR(150) NOT NULL,
  email    VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,                      -- mot de passe HASHÉ (bcrypt), jamais en clair
  role     ENUM('client', 'admin') NOT NULL DEFAULT 'client'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
--  Table products : le catalogue
-- ------------------------------------------------------------
CREATE TABLE products (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(200) NOT NULL,
  description TEXT,
  price       INT UNSIGNED NOT NULL,                   -- en FCFA
  image_url   VARCHAR(500),
  stock       INT UNSIGNED NOT NULL DEFAULT 0,
  category    VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
--  Table orders : les commandes
--  status : pending (en attente), paid (payée), processing (en préparation),
--           shipped (expédiée), delivered (livrée), cancelled (annulée)
-- ------------------------------------------------------------
CREATE TABLE orders (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  total_price INT UNSIGNED NOT NULL,                   -- en FCFA
  status      ENUM('pending','paid','processing','shipped','delivered','cancelled')
              NOT NULL DEFAULT 'pending',
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
--  Données : 16 produits du site ITHAVEN (8 catégories)
--  Les images sont dans le dossier images/ (voir README.md)
-- ------------------------------------------------------------
INSERT INTO products (name, description, price, image_url, stock, category) VALUES

-- Headphones
('Nova Pro Wireless Headphones',
 'Over-ear Bluetooth headphones with active noise cancellation, deep bass and up to 30 hours of battery life. Foldable design with a soft carrying pouch.',
 45000, 'images/nova-pro-headphones.png', 25, 'Headphones'),

('Pulse Buds True Wireless Earbuds',
 'Compact true wireless earbuds with a charging case, clear calls and up to 24 hours of total playtime. Water resistant, ideal for workouts.',
 18500, 'images/pulse-buds-earbuds.png', 60, 'Headphones'),

-- Smart Watches
('FitPulse Smart Watch',
 'AMOLED touchscreen smartwatch with heart-rate monitor, sleep tracking, step counter and more than 100 sport modes. Up to 7 days of battery life.',
 32000, 'images/fitpulse-smartwatch.png', 35, 'Smart Watches'),

('Active Band Fitness Tracker',
 'Lightweight fitness band with heart-rate and SpO2 monitoring, sleep tracking, call and message notifications, and up to 10 days of battery life.',
 14500, 'images/active-band-tracker.png', 70, 'Smart Watches'),

-- Smartphones
('Zenith X5 Smartphone',
 '6.6-inch AMOLED display, 8 GB RAM, 256 GB storage, 50 MP triple camera and a 5000 mAh battery with fast charging. Dual SIM.',
 185000, 'images/zenith-x5-smartphone.png', 20, 'Smartphones'),

('Zenith Lite A3 Smartphone',
 '6.5-inch HD+ display, 4 GB RAM, 128 GB storage, 13 MP camera and a 5000 mAh battery. A reliable everyday phone at an affordable price.',
 78000, 'images/zenith-lite-a3-smartphone.png', 40, 'Smartphones'),

-- Laptops
('AeroBook 15 Laptop',
 '15.6-inch Full HD laptop with an 8-core processor, 16 GB RAM, 512 GB SSD and a backlit keyboard. Ideal for work, study and multitasking.',
 425000, 'images/aerobook-15-laptop.png', 12, 'Laptops'),

('SlimBook 14 Ultrabook',
 'Ultralight 14-inch laptop with an aluminium body, 8 GB RAM, 256 GB SSD, Wi-Fi 6 and a battery that lasts all day.',
 310000, 'images/slimbook-14-ultrabook.png', 15, 'Laptops'),

-- Cameras
('Vision D200 DSLR Camera',
 '24 MP DSLR camera with an 18-55 mm lens, Full HD video, built-in Wi-Fi and a 3-inch screen. A great start for photography beginners.',
 340000, 'images/vision-d200-camera.png', 8, 'Cameras'),

('ActionCam 4K Sports Camera',
 '4K action camera with image stabilisation, a wide-angle lens, a waterproof case up to 30 m and a wrist remote control.',
 55000, 'images/actioncam-4k.png', 25, 'Cameras'),

-- Speakers
('BoomBox Portable Bluetooth Speaker',
 '20 W portable speaker with powerful bass, IPX6 water resistance, built-in microphone and up to 12 hours of battery life.',
 28000, 'images/boombox-speaker.png', 40, 'Speakers'),

('SoundBar Mini 2.1',
 '60 W compact soundbar with Bluetooth, HDMI ARC and optical input. Upgrade your TV sound in minutes.',
 52000, 'images/soundbar-mini.png', 18, 'Speakers'),

-- Gaming
('Striker Wireless Gamepad',
 'Ergonomic wireless controller with dual vibration, programmable back buttons and up to 20 hours of battery life. Compatible with PC and Android.',
 25000, 'images/striker-gamepad.png', 45, 'Gaming'),

('Phantom RGB Gaming Mouse',
 'Gaming mouse with up to 7200 DPI, RGB lighting, 7 programmable buttons and a braided cable for precision and durability.',
 15000, 'images/phantom-gaming-mouse.png', 50, 'Gaming'),

-- Drones
('SkyLite Mini Drone 4K',
 'Foldable mini drone with a 4K camera, 2-axis stabilisation, GPS return-to-home and 25 minutes of flight time. Lightweight and easy to carry.',
 165000, 'images/skylite-mini-drone.png', 10, 'Drones'),

('FlyEasy Beginner Drone',
 'Easy-to-fly drone with an HD camera, altitude hold, one-key take-off and landing, and two batteries included.',
 48000, 'images/flyeasy-drone.png', 22, 'Drones');