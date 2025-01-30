CREATE TABLE
    Users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        role ENUM ('Super Admin', 'User') DEFAULT 'User',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE
    Events (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        title VARCHAR(100) NOT NULL,
        description TEXT,
        location VARCHAR(255),
        event_date TIMESTAMP NOT NULL,
        start_time TIME NOT NULL,
        end_time TIME NOT NULL,
        visibility ENUM ('Private', 'Public') DEFAULT 'Public',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE
    );

-- Event Categories (Many-to-Many with Events)
CREATE TABLE
    Categories (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) UNIQUE NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE
    EventCategory (
        event_id INT NOT NULL,
        category_id INT NOT NULL,
        PRIMARY KEY (event_id, category_id),
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES Categories (id) ON DELETE CASCADE
    );

CREATE TABLE
    Images (
        id INT AUTO_INCREMENT PRIMARY KEY,
        event_id INT NOT NULL,
        image_url VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE
    );

CREATE TABLE
    Videos (
        id INT AUTO_INCREMENT PRIMARY KEY,
        event_id INT NOT NULL,
        video_url VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE
    );

CREATE TABLE
    Comments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        event_id INT NOT NULL,
        user_id INT NOT NULL,
        comment TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE
    );

CREATE TABLE
    Notifications (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        message TEXT NOT NULL,
        is_read BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE
    );