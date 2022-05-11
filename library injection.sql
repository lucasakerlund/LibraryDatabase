INSERT INTO `libraries` VALUES (1, "stockholms bibliotek", "stockholm 1", "Stockholms län");
INSERT INTO `libraries` VALUES (2, "Uppsalas bibliotek", "uppsala 1", "Spanien");
INSERT INTO `authors` VALUES (1,'fwefs');
INSERT INTO `authors` VALUES (2,'Asdwas');
INSERT INTO `genre` VALUES (1,'Action');
INSERT INTO `customers` VALUES(1, "Test", "test", "test", "123");
INSERT INTO `book_details` VALUES ("9781387207770",'Batman','Hello','EN','2022-05-06',"https://books.google.com/books?id=zyTCAlFPjgYC&printsec=frontcover&img=1&zoom=10&edge=curl&source=gbs_api",200);
INSERT INTO `book_details` VALUES ("1251253223423",
'Bergmästaren : krönikeroman, del 1',
'Bergmästaren del 1 och 2 är Rune Pär Olofssons sista verk. Romanerna handlar om den legendariske Hans Philip Lybecker som var bergmästare för Falu Gruva mellan åren 1644-1668. Rune Pär Olofsson föddes 1926 på Gotland och är en svensk författare, journalist och präst. Han har bland annat skrivit diktsamlingar, men är mest känd för sina historiska romaner. Den mest kända romansviten är om ätterna Brahe och Sparre under 1500-talet.',
'SE',
'2017-11-23',
"https://books.google.com/books/content?id=7UFADwAAQBAJ&printsec=frontcover&img=1&zoom=10&edge=curl&source=gbs_api",
98);
INSERT INTO `books` VALUES (1,'9781387207770', 1);
INSERT INTO `books` VALUES (2,'9781387207770', 1);
INSERT INTO `books` VALUES (3,'9781387207770', 1);
INSERT INTO `books` VALUES (4,'9781387207770', 2);
INSERT INTO `books` VALUES (5,'1251253223423', 2);
INSERT INTO `books_with_authors` VALUES ("9781387207770",1);
INSERT INTO `books_with_authors` VALUES ("9781387207770",2);
INSERT INTO `books_with_genre` VALUES ("9781387207770",1);
INSERT INTO `books_with_genre` VALUES ("1251253223423",1);