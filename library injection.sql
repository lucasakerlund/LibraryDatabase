INSERT INTO `libraries` VALUES (1, "stockholms bibliotek", "stockholm 1", "Stockholms län");
INSERT INTO `libraries` VALUES (2, "Uppsalas bibliotek", "uppsala 1", "Spanien");
INSERT INTO `authors` VALUES (1,'Igor');
INSERT INTO `authors` VALUES (2,'Asdwas');
INSERT INTO `genre` VALUES (1,'Action');
INSERT INTO `customers` VALUES(1, "Test", "test", "test", "123");
INSERT INTO `book_details` VALUES ("9781387207770",'Batman','Hello','EN','2022-05-06',"http://books.google.com/books/content?id=eNPfswEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",200);
INSERT INTO `book_details` VALUES ("1251253223423",'Batman','Hello','EN','2022-05-06',"http://books.google.com/books/content?id=eNPfswEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",200);
INSERT INTO `books` VALUES (1,'9781387207770', 1);
INSERT INTO `books` VALUES (2,'9781387207770', 1);
INSERT INTO `books` VALUES (3,'9781387207770', 1);
INSERT INTO `books` VALUES (4,'9781387207770', 2);
INSERT INTO `books` VALUES (5,'1251253223423', 2);
INSERT INTO `books_with_authors` VALUES ("9781387207770",1);
INSERT INTO `books_with_authors` VALUES ("9781387207770",2);
INSERT INTO `books_with_genre` VALUES ("9781387207770",1);
INSERT INTO `books_with_genre` VALUES ("1251253223423",1);
-- Stockholm bibliotek group_rooms
INSERT INTO `group_rooms` VALUES (1, "Focus", 1);
INSERT INTO `group_rooms` VALUES (2, "Mind", 1);
INSERT INTO `group_rooms` VALUES (3, "Discipline", 1);
INSERT INTO `group_rooms` VALUES (4, "Nerd", 1);
-- Uppsala bibliotek group_rooms
INSERT INTO `group_rooms` VALUES (5, "Einstein", 2);
INSERT INTO `group_rooms` VALUES (6, "Newton", 2);
INSERT INTO `group_rooms` VALUES (7, "Pascal", 2);
INSERT INTO `group_rooms` VALUES (8, "Bohr", 2);

INSERT INTO `customers_with_group_rooms` VALUES (1,1,1, "08:00-10:00");
INSERT INTO `customers_with_group_rooms` VALUES (1,2,1, "13:00-15:00");
INSERT INTO `customers_with_group_rooms` VALUES (2,2,1, "05:00-09:00");
INSERT INTO `customers_with_group_rooms` VALUES (4,2,2, "12:00-14:00");
INSERT INTO `customers_with_group_rooms` VALUES (3,1,2, "16:00-18:00");
INSERT INTO `customers_with_group_rooms` VALUES (1,2,2, "11:00-14:00");