-- Fix for personal_access_tokens table
-- Add the missing expires_at column that Laravel Sanctum requires

ALTER TABLE `personal_access_tokens` 
ADD COLUMN `expires_at` TIMESTAMP NULL DEFAULT NULL 
AFTER `abilities`;

-- Verify the table structure
DESCRIBE `personal_access_tokens`;