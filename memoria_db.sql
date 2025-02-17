-- Users Table
CREATE TABLE
    Users (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        avatar_path TEXT,
        role ENUM ('admin', 'moderator', 'user') NOT NULL DEFAULT 'user',
        status ENUM ('active', 'inactive', 'banned') NOT NULL DEFAULT 'active',
        email_verified_at TIMESTAMP NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- Categories Table
CREATE TABLE
    Categories (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        icon_type ENUM (
            'Activity',
            'Airplay',
            'AlertCircle',
            'AlertOctagon',
            'AlertTriangle',
            'AlignCenter',
        ) NOT NULL,
        description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- Events Table
CREATE TABLE
    Events (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        date DATE NOT NULL,
        start_time TIME NOT NULL,
        end_time TIME NOT NULL,
        description TEXT,
        author_id BIGINT UNSIGNED,
        max_capacity INT UNSIGNED,
        current_capacity INT UNSIGNED DEFAULT 0,
        registration_deadline DATETIME,
        status ENUM ('draft', 'published', 'cancelled', 'completed') NOT NULL DEFAULT 'draft',
        visibility ENUM ('public', 'private', 'invite_only') NOT NULL DEFAULT 'public',
        category_id BIGINT UNSIGNED,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (author_id) REFERENCES Users (id) ON DELETE SET NULL,
        FOREIGN KEY (category_id) REFERENCES Categories (id) ON DELETE SET NULL
    );

-- Locations Table
CREATE TABLE
    Locations (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        event_id BIGINT UNSIGNED,
        name VARCHAR(255) NOT NULL,
        address TEXT NOT NULL,
        lat DECIMAL(9, 6),
        lng DECIMAL(9, 6),
        mapEmbedUrl TEXT,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE
    );

-- Media Table
CREATE TABLE
    Media (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        event_id BIGINT UNSIGNED,
        type ENUM ('image', 'video') NOT NULL,
        file_path TEXT NOT NULL,
        thumbnail_path TEXT,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE
    );

-- User Event Status Table
CREATE TABLE
    UserEventStatus (
        user_id BIGINT UNSIGNED,
        event_id BIGINT UNSIGNED,
        status ENUM ('interested', 'not_going', 'going') NOT NULL,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (user_id, event_id),
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE
    );

-- Event Posts Table
CREATE TABLE
    EventPosts (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        event_id BIGINT UNSIGNED,
        author_id BIGINT UNSIGNED,
        content TEXT NOT NULL,
        visibility ENUM ('public', 'private') NOT NULL DEFAULT 'public',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE,
        FOREIGN KEY (author_id) REFERENCES Users (id) ON DELETE SET NULL
    );

-- Event Post Media Table
CREATE TABLE
    EventPostMedia (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        post_id BIGINT UNSIGNED,
        type ENUM ('image', 'video') NOT NULL,
        file_path TEXT NOT NULL,
        thumbnail_path TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (post_id) REFERENCES EventPosts (id) ON DELETE CASCADE
    );

-- Event Post Likes Table
CREATE TABLE
    EventPostLikes (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        post_id BIGINT UNSIGNED NOT NULL,
        user_id BIGINT UNSIGNED NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (post_id) REFERENCES EventPosts (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
        UNIQUE KEY unique_post_like (post_id, user_id)
    );

-- Event Post Comments Table
CREATE TABLE
    EventPostComments (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        post_id BIGINT UNSIGNED NOT NULL,
        user_id BIGINT UNSIGNED NOT NULL,
        content TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (post_id) REFERENCES EventPosts (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE
    );

-- Event Post Reposts Table
CREATE TABLE
    EventPostReposts (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        post_id BIGINT UNSIGNED NOT NULL,
        user_id BIGINT UNSIGNED NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (post_id) REFERENCES EventPosts (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
        UNIQUE KEY unique_post_repost (post_id, user_id)
    );

-- Event Post Tags Table
CREATE TABLE
    EventPostTags (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_post_tag_name (name)
    );

-- Event Post Tag Relations Table
CREATE TABLE
    EventPostTagRelations (
        post_id BIGINT UNSIGNED NOT NULL,
        tag_id BIGINT UNSIGNED NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (post_id, tag_id),
        FOREIGN KEY (post_id) REFERENCES EventPosts (id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES EventPostTags (id) ON DELETE CASCADE
    );

-- Notifications Table
CREATE TABLE
    Notifications (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        user_id BIGINT UNSIGNED NOT NULL,
        related_user_id BIGINT UNSIGNED,
        event_id BIGINT UNSIGNED,
        post_id BIGINT UNSIGNED,
        type ENUM (
            'event_invite',
            'event_update',
            'new_post',
            'post_like',
            'post_comment',
            'post_repost',
            'new_follower'
        ) NOT NULL,
        message TEXT NOT NULL,
        is_read BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE,
        FOREIGN KEY (related_user_id) REFERENCES Users (id) ON DELETE SET NULL,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE,
        FOREIGN KEY (post_id) REFERENCES EventPosts (id) ON DELETE CASCADE
    );

-- User Relationships Table
CREATE TABLE
    UserRelationships (
        follower_id BIGINT UNSIGNED NOT NULL,
        following_id BIGINT UNSIGNED NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (follower_id, following_id),
        FOREIGN KEY (follower_id) REFERENCES Users (id) ON DELETE CASCADE,
        FOREIGN KEY (following_id) REFERENCES Users (id) ON DELETE CASCADE
    );

-- Event Tags Table
CREATE TABLE
    EventTags (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_tag_name (name)
    );

-- Event Tag Relations Table
CREATE TABLE
    EventTagRelations (
        event_id BIGINT UNSIGNED NOT NULL,
        tag_id BIGINT UNSIGNED NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (event_id, tag_id),
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES EventTags (id) ON DELETE CASCADE
    );