INSERT INTO `libraries` VALUES (1, "stockholms bibliotek", "stockholm 1", "Stockholms län");
INSERT INTO `libraries` VALUES (2, "Uppsalas bibliotek", "uppsala 1", "Spanien");
INSERT INTO `authors` VALUES (1,'Igor');
INSERT INTO `authors` VALUES (2,'Asdwas');
INSERT INTO `genre` VALUES (1,'Action');
INSERT INTO `genre` VALUES (2,'Comedy');
INSERT INTO `genre` VALUES (3,'Scifi');
INSERT INTO `book_details` VALUES ("9781387207770",'Batman','Hello','EN','2022-05-06',"http://books.google.com/books/content?id=lN_QDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",200);
INSERT INTO `book_details` VALUES ("1251253223423",'Tjenare','Hello','EN','2022-05-06',"http://books.google.com/books/content?id=-dCApIOKqa8C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",200);
INSERT INTO `book_details` VALUES ("4324152352335",'Hejsan','Hello','SE','2022-05-06',"http://books.google.com/books/content?id=t12AuG0q144C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",200);
INSERT INTO `book_details` VALUES ("5423523543633",'Robin','Hello','EN','2022-05-06',"http://books.google.com/books/content?id=9fCipszqj68C&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",200);
INSERT INTO `books` VALUES (1,'9781387207770', 1);
INSERT INTO `books` VALUES (2,'9781387207770', 1);
INSERT INTO `books` VALUES (3,'9781387207770', 1);
INSERT INTO `books` VALUES (4,'9781387207770', 2);
INSERT INTO `books` VALUES (5,'1251253223423', 2);
INSERT INTO `books` VALUES (6,'1251253223423', 1);	
INSERT INTO `books` VALUES (7,'1251253223423', 1);
INSERT INTO `books` VALUES (8,'1251253223423', 1);
INSERT INTO `books` VALUES (9,'1251253223423', 1);
INSERT INTO `books` VALUES (10,'1251253223423', 1);
INSERT INTO `books` VALUES (11,'1251253223423', 1);
INSERT INTO `books` VALUES (12,'1251253223423', 1);
INSERT INTO `books` VALUES (13,'1251253223423', 2);
INSERT INTO `books_with_authors` VALUES ("9781387207770",1);
INSERT INTO `books_with_authors` VALUES ("9781387207770",2);
INSERT INTO `books_with_genre` VALUES ("9781387207770",1);
INSERT INTO `books_with_genre` VALUES ("9781387207770",2);
INSERT INTO `books_with_genre` VALUES ("1251253223423",2);
INSERT INTO `books_with_genre` VALUES ("1251253223423",3);
INSERT INTO `books_with_genre` VALUES ("4324152352335",2);
INSERT INTO `books_with_genre` VALUES ("5423523543633",3);
-- Stockholm bibliotek group_rooms
INSERT INTO `group_rooms` VALUES (1, "Focus", 1, "Ett magiskt och vackert litet rum, byggt för lugn och ro. Rummet maximerar focuset hos dig och din arbetsgrupp!");
INSERT INTO `group_rooms` VALUES (2, "Mind", 1, "Ett sketet rum");
INSERT INTO `group_rooms` VALUES (3, "Discipline", 1, "Ett sketet rum");
INSERT INTO `group_rooms` VALUES (4, "Nerd", 1, "Ett sketet rum");








-- Stockholm bibliotek times
INSERT INTO `group_room_times` (room_id, time, date) VALUES (1, '08:00-10:00', '2022-05-24');
INSERT INTO `group_room_times` (room_id, time, date) VALUES (1, '10:00-12:00', '2022-05-24');
INSERT INTO `group_room_times` (room_id, time, date) VALUES (1, '12:00-14:00', '2022-05-24');
INSERT INTO `group_room_times` (room_id, time, date) VALUES (1, '14:00-16:00', '2022-05-24');
INSERT INTO `group_room_times` (room_id, time, date) VALUES (1, '16:00-18:00', '2022-05-24');
INSERT INTO `group_room_times` (room_id, time, date) VALUES (2, '16:00-18:00', '2022-05-24');

-- Uppsala bibliotek group_rooms
INSERT INTO `group_rooms` VALUES (5, "Einstein", 2, "Ett sketet rum");
INSERT INTO `group_rooms` VALUES (6, "Newton", 2, "Ett sketet rum");
INSERT INTO `group_rooms` VALUES (7, "Pascal", 2, "Ett sketet rum");
INSERT INTO `group_rooms` VALUES (8, "Bohr", 2, "Ett sketet rum");