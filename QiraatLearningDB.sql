DROP DATABASE QiraatLearningDB;
CREATE DATABASE QiraatLearningDB;
USE QiraatLearningDB;

CREATE TABLE AcademicQualifications
(
	AcademicQualificationID INT AUTO_INCREMENT PRIMARY KEY,
	Title VARCHAR(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO AcademicQualifications(Title)
VALUES ('ثانوية ازهرية'), ('ثانوية عامة'), ('جامعة الازهر'), ('جامعة عام'), ('اخرى');


CREATE TABLE Applications
(
	ApplicationID INT AUTO_INCREMENT PRIMARY KEY,
	FullName VARCHAR(200) NOT NULL,
	Age INT NOT NULL CHECK (Age BETWEEN 10 AND 80),

	AcademicQualificationID INT NOT NULL,
	Gender TINYINT(1) NOT NULL,

	Address LONGTEXT NULL,
	Phone VARCHAR(20) NOT NULL,

	TestDate DATETIME NULL,

	CreatedAt DATETIME NOT NULL DEFAULT NOW(),

	CONSTRAINT FK_Applications_AcademicQualifications
	FOREIGN KEY (AcademicQualificationID)
	REFERENCES AcademicQualifications(AcademicQualificationID)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Playlists
(
	PlaylistID INT AUTO_INCREMENT PRIMARY KEY,
	Title VARCHAR(600) NOT NULL,
	Cover VARCHAR(600) NOT NULL,
	Notes VARCHAR(255) NULL,

	CreatedAt DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Videos 
(
	VideoID INT AUTO_INCREMENT PRIMARY KEY,
	Title VARCHAR(600) NOT NULL,
	URL_Embed LONGTEXT NOT NULL,

	PlaylistID INT NOT NULL,

	CreatedAt DATETIME NOT NULL DEFAULT NOW(),

	CONSTRAINT FK_Videos_Playlists
	FOREIGN KEY (PlaylistID)
	REFERENCES Playlists(PlaylistID)
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Questions
(
	QuestionID INT AUTO_INCREMENT PRIMARY KEY,
	Title VARCHAR(600) NOT NULL,
	VideoID INT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT NOW(),

	CONSTRAINT FK_Questions_Videos
	FOREIGN KEY (VideoID)
	REFERENCES Videos(VideoID)
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Choices
(
	ChoiceID INT AUTO_INCREMENT PRIMARY KEY,
	QuestionID INT NOT NULL,
	Choice VARCHAR(600) NOT NULL,
	IsTrue TINYINT(1) NOT NULL DEFAULT 0,

	CONSTRAINT FK_Choices_Questions
	FOREIGN KEY (QuestionID)
	REFERENCES Questions(QuestionID)
	ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX IX_Applications_AcademicQualificationID 
ON Applications(AcademicQualificationID);
CREATE INDEX IX_Videos_PlaylistID 
ON Videos(PlaylistID);
CREATE INDEX IX_Questions_VideoID 
ON Questions(VideoID);
CREATE INDEX IX_Choices_QuestionID 
ON Choices(QuestionID);

-- Enforces only one correct answer per question using a functional index (MySQL 8.0+)
CREATE UNIQUE INDEX UX_Choices_OneTrueAnswer
ON Choices((CASE WHEN IsTrue = 1 THEN QuestionID END));
INSERT INTO Playlists (Title, Cover) VALUES
('شرح متن الشاطبية - أ. د مصطفى الحلوس - عضو هيئة التدريس بكلية القرآن بطنطا', 'Images/Cover1.jpg'),
('شرح متن الدرة - فضيلة أ.د مصطفى الحلوس عضو هيئة التدريس بكلية القرآن بطنطا', 'Images/Cover2.jpg'),
('تحريرات الشاطبية و الدرة - أ. د مصطفى الحلوس.', 'Images/Cover3.jpg');

INSERT INTO Videos (Title, URL_Embed, PlaylistID) VALUES
('شرح متن الشاطبية - ٢ - شرح مقدمة الشاطبية جزء ثاني.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/ci-4RwjOdA8', 1),
('شرح متن الشاطبية - ٣- شرح مقدمة الشاطبية جزء ثالث.. أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/5vgMOCuoDh8', 1),
('شرح متن الشاطبية - ٤- شرح مقدمة الشاطبية جزء رابع.. أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/9S_xyX92s14', 1),
('شرح متن الشاطبية - ٥ - شرح مقدمة الشاطبية جزء خامس.. أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/2Eg_aj6G5qI', 1),
('شرح متن الشاطبية - ٦- شرح مقدمة الشاطبية جزء سادس.. أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/LLsFdfyxgK8', 1),
('شرح متن الشاطبية - ٧ - باب الإستعاذة و البسملة..  فضيلة أ. د مصطفى الحلوس..', 'https://www.youtube.com/embed/T52g6kC10X0', 1),
('شرح متن الشاطبية - ٨ - سورة أم القرآن.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/IDbWmdWnoS4', 1),
('شرح متن الشاطبية - ٩ - باب الإدغام الكبير.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/r5ZAp4VaPmY', 1),
('شرح متن الشاطبية - ١٠ - إدغام الحرفين المتقاربين فى كلمة و فى كلمتين ج١.. أ. د. مصطفى الحلوس.', 'https://www.youtube.com/embed/IRkhhTpnNR8', 1),
('شرح متن الشاطبية - ١١ - إدغام الحرفين المتقاربين فى كلمة و فى كلمتين ج٢ .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/QhS3grSXi0I', 1),
('شرح متن الشاطبية - ١٢ - باب هاء الكناية.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/z8__eYP3364', 1),
('شرح متن الشاطبية - ١٣ - باب المد و القصر ج١.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/N0RjwMaX-SA', 1),
('شرح متن الشاطبية - ١٤ - باب المد و القصر ج٢.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/zPZr2ij-prA', 1),
('شرح متن الشاطبية - ١٥ - باب الهمزتين من كلمة.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/fstISYidBeo', 1),
('شرح متن الشاطبية - ١٦ - باب الهمزتين من كلمتين.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/bUb9q6Q9Dcw', 1),
('شرح متن الشاطبية - ١٧ - باب الهمز المفرد .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/qKp3hq1R13g', 1),
('شرح متن الشاطبية - ١٨ - نقل حركة الهمزة إلى الساكن قبلها .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/IfXKkODbsEI', 1),
('شرح متن الشاطبية - ١٩ - تأصيل وقف حمزة و هشام على الهمز .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/qM-rx1kf2KM', 1),
('شرح متن الشاطبية - ٢٠ - باب وقف حمزة و هشام على الهمز .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/iJ3vK4UTrR8', 1),
('شرح متن الشاطبية - ٢١ - باب الإظهار و الإدغام .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/uQQHkxGFwf0', 1),
('شرح متن الشاطبية - ٢٢ - حروف قربت مخارجها و النون الساكنة والتنوين .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/HmTOzW4Da2c', 1),
('شرح متن الشاطبية - ٢٣ - الفتح و الإمالة و بين اللفظين ج١.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/ew0GoNqLKNc', 1),
('شرح متن الشاطبية - ٢٤ - الفتح و الإمالة و بين اللفظين ج٢.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/Zs7vDm9osmo', 1),
('شرح متن الشاطبية - ٢٥ - الفتح و الإمالة و بين اللفظين ج٣.. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/AGFG8IEVz-I', 1),
('شرح متن الشاطبية - ٢٦ - مذهب الكسائي في إمالة هاء التأنيث و ما قبلها عند الوقف.. أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/2DTq4unorNw', 1),
('شرح متن الشاطبية - ٢٧ - مذاهبهم فى الراءات .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/dyCQ3amgAzs', 1),
('شرح متن الشاطبية - ٢٨ - باب اللامات .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/jEuLnWSoyNU', 1),
('شرح متن الشاطبية - ٢٩ - الوقف على أواخر الكلم ج١ .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/OcfM1UkNXvA', 1),
('شرح متن الشاطبية - ٣٠ - الوقف على أواخر الكلم ج١ .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/0MM1Y7vbczY', 1),
('شرح متن الشاطبية - ٣١ - ياءات الإضافة .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/g39qtl_WNKA', 1),
('شرح متن الشاطبية - ٣٢ و الأخير فى أصول الشاطبية - ياءات الزوائد .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/VwMjjA_YWys', 1),
('شرح متن الشاطبية - ٣٣ - فرش البقرة ج١ .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/UfgjaXYoPpM', 1),
('شرح متن الشاطبية - ٣٤ - فرش البقرة ج٢ .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/A2y39O_z-9Q', 1),
('شرح متن الشاطبية - ٣٤ - فرش البقرة ج٢ .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/R_u_srIcK8E', 1),
('شرح متن الشاطبية - ٣٥ - فرش البقرة ج٣ .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/gNG2XnXoJKo', 1),
('شرح متن الشاطبية - ٣٦ - فرش البقرة ج٤ .. فضيلة أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/jEzT_oAb6aQ', 1),
('شرح متن الشاطبية - ٣٧ - فرش البقرة ج٥ .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/tPr1xzCmbHM', 1),
('شرح متن الشاطبية - ٣٨ - فرش البقرة ج٦ .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/htveD6xqH2k', 1),
('شرح متن الشاطبية - ٣٩ - فرش البقرة ج٧ .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/qQgKwAY5uog', 1),
('شرح متن الشاطبية - ٤٠ - فرش آل عمران ج١ .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/1jbpwVUBxwY', 1),
('شرح متن الشاطبية - ٤١ - آل عمران ج٢ .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/tPPZMdbNkPQ', 1),
('شرح متن الشاطبية - ٤٢ - آل عمران ج٣ .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/TbPr9nV7Jgo', 1),
('شرح متن الشاطبية - ٤٣ - النساء ج١ .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/a4nJG7FZAvI', 1),
('شرح متن الشاطبية - ٤٤ - النساء ج٢.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/aO3v_Xbkso8', 1),
('شرح متن الشاطبية - ٤٥ - المائدة .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/s-vjJBzUS-4', 1),
('شرح متن الشاطبية - ٤٦ - الأنعام ج١.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/Vz4e6gLRN-M', 1),
('شرح متن الشاطبية - ٤٧ - الأنعام ج٢.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/Rcsl3_zqQA8', 1),
('شرح متن الشاطبية - ٤٨ - الأنعام ج٣.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/72TxdsiphK8', 1),
('شرح متن الشاطبية - ٤٩ - الأعراف ج١.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/m43wFRWAbX0', 1),
('شرح متن الشاطبية - ٥٠ - الأعراف ج٢.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/z0XeF8GC0Is', 1),
('شرح متن الشاطبية - ٥١ - الأعراف ج٣.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/1ssUrX_6Qc8', 1),
('شرح متن الشاطبية - ٥٢ - الأنفال .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/yeh1y9-WPK8', 1),
('شرح متن الشاطبية - ٥٣ - التوبة.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/D047DBhFF3Y', 1),
('شرح متن الشاطبية - ٥٤ - يونس .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/QSetx7PLDXo', 1),
('شرح متن الشاطبية - ٥٥ - هود .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/RZyeYXQokBQ', 1),
('شرح متن الشاطبية - ٥٦ - يوسف .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/4FBbili5J6o', 1),
('شرح متن الشاطبية - ٥٧ - الرعد .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/VV3KxsE-c0E', 1),
('شرح متن الشاطبية - ٥٨ - إبراهيم .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/cgMWTHjYUM0', 1),
('شرح متن الشاطبية - ٥٩ - الحجر .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/4-ZjXJPtnkw', 1),
('شرح متن الشاطبية - ٦٠ - النحل .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/t6qoKGsyOhk', 1),
('شرح متن الشاطبية - ٦١ - الإسراء .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/SCqNbjEQbEM', 1),
('شرح متن الشاطبية - ٦٢ - الكهف ج١.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/WnTomS6EBRo', 1),
('شرح متن الشاطبية - ٦٣ - الكهف ج٢.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/V-5_ueBkR2w', 1),
('شرح متن الشاطبية - ٦٤ - طه .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/ONc24gDUtJg', 1),
('شرح متن الشاطبية - ٦٥ - الأنبياء .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/NWT_DQwhWXw', 1),
('شرح متن الشاطبية - ٦٦ - الحج .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/StB4Jkx0Q7k', 1),
('شرح متن الشاطبية - ٦٧ - المؤمنون.. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/sxL25y3pkbk', 1),
('شرح متن الشاطبية - ٦٨ - النور .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/KoSJjJkF0l4', 1),
('شرح متن الشاطبية - ٦٩ - الفرقان .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/cFvI4zarP14', 1),
('شرح متن الشاطبية - ٧٠ - الشعراء .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/au85fsuVbu0', 1),
('شرح متن الشاطبية - ٧١ - النمل .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/Eunu1xZ5kDk', 1),
('شرح متن الشاطبية - ٧٢ - القصص .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/UHl9j9Svnv0', 1),
('شرح متن الشاطبية - ٧٣ - العنكبوت .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/4S4usY13Uq0', 1),
('شرح متن الشاطبية - ٧٤ - من الروم إلى سبأ .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/JrhSBPIqKG0', 1),
('شرح متن الشاطبية - ٧٥ - الأحزاب .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/3X-faeDZc3g', 1),
('شرح متن الشاطبية - ٧٦ - سبأ و فاطر .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/DpMVXZL7oNQ', 1),
('شرح متن الشاطبية - ٧٧ - يسن .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/mqN_9X_RVAs', 1),
('شرح متن الشاطبية - ٧٨ - الصافات .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/xILI5re1tHI', 1),
('شرح متن الشاطبية - ٧٩ - ص .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/BL3mujCNRrU', 1),
('شرح متن الشاطبية - ٨٠ - الزمر .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/MVBzS23iMuQ', 1),
('شرح متن الشاطبية - ٨١ - غافر .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/OACxFobzCEE', 1),
('شرح متن الشاطبية - ٨٢ - فصلت .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/ZYnECiv3J5Y', 1),
('شرح متن الشاطبية - ٨٣ - الشورى-الزخرف - الدخان .. فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/HFgabtAtVHo', 1);
INSERT INTO Videos (Title, URL_Embed, PlaylistID) VALUES
('شرح متن الدرة - ١ المقدمة  - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/xhUL1rqwmgY', 2),
('شرح متن الدرة - ٢ البسملة و أم القرآن - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/MhvaJC--PFo', 2),
('شرح متن الدرة - ٣ الإدغام الكبير - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/WTiXeKSbx88', 2),
('شرح متن الدرة - ٤ هاء الكناية - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/0XhbXh2SEL0', 2),
('شرح متن الدرة - ٥ المد و القصر ، الهمزتان من كلمة ، الهمزتان من كلمتين - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/RjCwTVPkPa8', 2),
('شرح متن الدرة - ٦ الهمز المفرد - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/Bakp7BglA_c', 2),
('شرح متن الدرة - ٧ النقل و السكت ،  الإدغام الصغير ، النون الساكنة والتنوين - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/-OpZga2KhS0', 2),
('شرح متن الدرة - ٨ الفتح و الإمالة - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/QZ6xEPS6GV8', 2),
('شرح متن الدرة - ٩ اللامات ، الراءات ، الوقف على المرسوم - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/C-ckVYJKVNM', 2),
('شرح متن الدرة - ١٠ ياءات الإضافة - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/s6PlikOqKCw', 2),
('شرح متن الدرة - ١١ - ياءات الزوائد - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/9ScA8GweaOQ', 2),
('شرح متن الدرة - ١٢ فرش البقرة ج١ - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/i_qyIoj97Fc', 2),
('شرح متن الدرة - ١٣ البقرة ج٢ - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/UZmIPVKisx4', 2),
('شرح متن الدرة - ١٤ فرش البقرة ج٣ - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/3OiWgBq40IY', 2),
('شرح متن الدرة - ١٥ فرش آل عمران - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/lk0u_QOnylw', 2),
('شرح متن الدرة - ١٦ فرش النساء و المائدة - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/Y4YLoHRIMLs', 2),
('شرح متن الدرة - ١٧ تكملة فرش المائدة - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/cnlDwVbmot4', 2),
('شرح متن الدرة - ١٨ فرش الأنعام - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/gT5_GaMzcbI', 2),
('شرح متن الدرة - ١٩ فرش الأعراف و الأنفال - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/xVtTDnwa1rk', 2),
('شرح متن الدرة - ٢٠ فرش التوبة و يونس و هود  - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/FiezmWgwibw', 2),
('شرح متن الدرة - ٢١ فرش يوسف - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/A2IoEkpDoGc', 2),
('شرح متن الدرة - ٢٢ فرش إبراهيم - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/e7TooLNrO48', 2),
('شرح متن الدرة - ٢٣ فرش الحجر و النحل - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/5dPGAx2ULN8', 2),
('شرح متن الدرة - ٢٤ الإسراء - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/VwfkdruuYEE', 2),
('شرح متن الدرة - ٢٥ الكهف - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/dA2RjOZ1EDw', 2),
('شرح متن الدرة - ٢٦ مريم و طه - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/8YClwNa8okM', 2),
('شرح متن الدرة - ٢٧ الأنبياء - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/yoKWG4bI_2M', 2),
('شرح متن الدرة - ٢٨ من الفرقان إلى الروم - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/dL0T-B-L7Xk', 2),
('شرح متن الدرة - ٢٩ الروم و لقمان و السجدة  - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/UW_bqJMefXs', 2),
('شرح متن الدرة - ٣٠ الأحزاب و سبأ و فاطر - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/Mvm7T-O7NXI', 2),
('شرح متن الدرة - ٣١ يٰسن و الصافات - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/Sjt_zMG76k4', 2),
('شرح متن الدرة - ٣٢ من ص إلى فصلت - فضيلة أ. د مصطفى الحلوس', 'https://www.youtube.com/embed/BXmA0dparQ4', 2);
INSERT INTO Videos (Title, URL_Embed, PlaylistID) VALUES
('تحريرات الشاطبية و الدرة - ١ مقدمة - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/3QT61n_ihv8', 3),
('تحريرات الشاطبية و الدرة - ٢ الإدغام الكبير - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/5ZuKa1NqS70', 3),
('تحريرات الشاطبية و الدرة - ٣ الإستعاذة.. صراط.. بين السورتين - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/k8qM5RNkAa4', 3),
('تحريرات الشاطبية و الدرة - ٤ حروف التهجي - السكت... و غيرهما - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/E2--nkJe63s', 3),
('تحريرات الشاطبية و الدرة - ٥ مد البدل لورش - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/5EteDmVSSLg', 3),
('تحريرات الشاطبية و الدرة - ٦ تحريرات ورش ج٢ - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/p6GaDSuD8XM', 3),
('تحريرات الشاطبية و الدرة - ٧ تحريرات هامة متفرقة منها سكت إدريس - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/56D3sLFeaNY', 3),
('تحريرات الشاطبية و الدرة - ٨ تحريرات هؤلاء إن - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/Fz2_XIfaY4A', 3),
('تحريرات الشاطبية و الدرة - ٩ تاءات البزي - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/27hFUUZcAos', 3),
('تحريرات الشاطبية و الدرة - ١٠ تحريرات هامة منها.. نعما.. التوراه - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/j3D4kifVgOs', 3),
('تحريرات الشاطبية و الدرة - ١١ هاء السكت ليعقوب - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/WZA4vz8t_No', 3),
('أسئلة متفرقة في تحريرات الشاطبية و الدرة - أ. د مصطفى الحلوس.', 'https://www.youtube.com/embed/vyQVT-ACcJU', 3);

-- ============================================================
-- SQL INSERT Script: Questions + Choices (All 3 Playlists)
-- Playlist 1: VideoID  1 -  82 (82 videos, 328 questions)
-- Playlist 2: VideoID 83 - 114 (32 videos, 128 questions)
-- Playlist 3: VideoID 115 - 126 (12 videos,  48 questions)
-- Total: 504 Questions | 2016 Choices
-- ============================================================

-- ============================================================
-- PLAYLIST 1 (VideoID 1 - 82)
-- ============================================================

-- Video 1: شرح مقدمة الشاطبية جزء ثاني
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 1)', 1);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(1, 'الواو الأصلية', 0),
(1, 'واو الفصل بين الرموز', 1),
(1, 'واو العطف', 0),
(1, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 2)', 1);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(2, 'نافع', 0),
(2, 'ابن كثير', 1),
(2, 'ورش', 0),
(2, 'ورش عن نافع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 3)', 1);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(3, 'الواو الأصلية', 0),
(3, 'واو الفصل بين الرموز', 1),
(3, 'واو العطف', 0),
(3, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 4)', 1);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(4, 'نافع', 0),
(4, 'ابن كثير', 1),
(4, 'ورش', 0),
(4, 'ورش عن نافع', 0);


-- Video 2: شرح مقدمة الشاطبية جزء ثالث
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 1)', 2);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(5, 'الواو الأصلية', 0),
(5, 'واو الفصل بين الرموز', 1),
(5, 'واو العطف', 0),
(5, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 2)', 2);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(6, 'نافع', 0),
(6, 'ابن كثير', 1),
(6, 'ورش', 0),
(6, 'ورش عن نافع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 3)', 2);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(7, 'الواو الأصلية', 0),
(7, 'واو الفصل بين الرموز', 1),
(7, 'واو العطف', 0),
(7, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 4)', 2);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(8, 'نافع', 0),
(8, 'ابن كثير', 1),
(8, 'ورش', 0),
(8, 'ورش عن نافع', 0);


-- Video 3: شرح مقدمة الشاطبية جزء رابع
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 1)', 3);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(9, 'الواو الأصلية', 0),
(9, 'واو الفصل بين الرموز', 1),
(9, 'واو العطف', 0),
(9, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 2)', 3);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(10, 'نافع', 0),
(10, 'ابن كثير', 1),
(10, 'ورش', 0),
(10, 'ورش عن نافع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 3)', 3);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(11, 'الواو الأصلية', 0),
(11, 'واو الفصل بين الرموز', 1),
(11, 'واو العطف', 0),
(11, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 4)', 3);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(12, 'نافع', 0),
(12, 'ابن كثير', 1),
(12, 'ورش', 0),
(12, 'ورش عن نافع', 0);


-- Video 4: شرح مقدمة الشاطبية جزء خامس
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 1)', 4);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(13, 'الواو الأصلية', 0),
(13, 'واو الفصل بين الرموز', 1),
(13, 'واو العطف', 0),
(13, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 2)', 4);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(14, 'نافع', 0),
(14, 'ابن كثير', 1),
(14, 'ورش', 0),
(14, 'ورش عن نافع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 3)', 4);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(15, 'الواو الأصلية', 0),
(15, 'واو الفصل بين الرموز', 1),
(15, 'واو العطف', 0),
(15, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 4)', 4);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(16, 'نافع', 0),
(16, 'ابن كثير', 1),
(16, 'ورش', 0),
(16, 'ورش عن نافع', 0);


-- Video 5: شرح مقدمة الشاطبية جزء سادس
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 1)', 5);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(17, 'الواو الأصلية', 0),
(17, 'واو الفصل بين الرموز', 1),
(17, 'واو العطف', 0),
(17, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 2)', 5);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(18, 'نافع', 0),
(18, 'ابن كثير', 1),
(18, 'ورش', 0),
(18, 'ورش عن نافع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما المقصود بـ ''الواو'' في قوله: ''وبالواو فاصلا'' في اصطلاح الشاطبي؟ (سؤال 3)', 5);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(19, 'الواو الأصلية', 0),
(19, 'واو الفصل بين الرموز', 1),
(19, 'واو العطف', 0),
(19, 'واو الجمع', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الذي يرمز له الشاطبي بحرف ''الجيم''؟ (سؤال 4)', 5);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(20, 'نافع', 0),
(20, 'ابن كثير', 1),
(20, 'ورش', 0),
(20, 'ورش عن نافع', 0);


-- Video 6: باب الإستعاذة و البسملة
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو مذهب حمزة في الفصل بين السورتين؟ (سؤال 1)', 6);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(21, 'البسملة', 0),
(21, 'السكت فقط', 0),
(21, 'الوصل بلا بسملة', 1),
(21, 'البسملة والسكت', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('أي من الأوجه التالية يمتنع عند الجمع بين السورتين؟ (سؤال 2)', 6);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(22, 'قطع الجميع', 0),
(22, 'وصل الجميع', 0),
(22, 'وصل الأول بالثاني وقطع الثالث', 1),
(22, 'قطع الأول ووصل الثاني بالثالث', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو مذهب حمزة في الفصل بين السورتين؟ (سؤال 3)', 6);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(23, 'البسملة', 0),
(23, 'السكت فقط', 0),
(23, 'الوصل بلا بسملة', 1),
(23, 'البسملة والسكت', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('أي من الأوجه التالية يمتنع عند الجمع بين السورتين؟ (سؤال 4)', 6);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(24, 'قطع الجميع', 0),
(24, 'وصل الجميع', 0),
(24, 'وصل الأول بالثاني وقطع الثالث', 1),
(24, 'قطع الأول ووصل الثاني بالثالث', 0);


-- Video 7: سورة أم القرآن
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 7);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(25, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(25, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(25, 'بضم الزاي والفاء وواو مفتوحة', 0),
(25, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 7);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(26, 'نافع', 0),
(26, 'أبو عمرو', 0),
(26, 'الكوفيون وابن عامر', 1),
(26, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 7);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(27, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(27, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(27, 'بضم الزاي والفاء وواو مفتوحة', 0),
(27, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 7);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(28, 'نافع', 0),
(28, 'أبو عمرو', 0),
(28, 'الكوفيون وابن عامر', 1),
(28, 'ابن كثير', 0);


-- Video 8: باب الإدغام الكبير
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي العلة في منع إدغام ''واسعٌ عليم'' عند السوسي؟ (سؤال 1)', 8);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(29, 'لأنه منون', 1),
(29, 'لأن الحرف الأول مشدد', 0),
(29, 'لأنه خبر', 0),
(29, 'لأنه اسم فاعل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً في إدغام ''بيت طائفة'' للسوسي؟ (سؤال 2)', 8);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(30, 'وجه واحد', 1),
(30, 'وجهان', 0),
(30, 'ثلاثة أوجه', 0),
(30, 'امتناع الإدغام', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي العلة في منع إدغام ''واسعٌ عليم'' عند السوسي؟ (سؤال 3)', 8);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(31, 'لأنه منون', 1),
(31, 'لأن الحرف الأول مشدد', 0),
(31, 'لأنه خبر', 0),
(31, 'لأنه اسم فاعل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً في إدغام ''بيت طائفة'' للسوسي؟ (سؤال 4)', 8);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(32, 'وجه واحد', 1),
(32, 'وجهان', 0),
(32, 'ثلاثة أوجه', 0),
(32, 'امتناع الإدغام', 0);


-- Video 9: إدغام الحرفين المتقاربين فى كلمة و فى كلمتين
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي العلة في منع إدغام ''واسعٌ عليم'' عند السوسي؟ (سؤال 1)', 9);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(33, 'لأنه منون', 1),
(33, 'لأن الحرف الأول مشدد', 0),
(33, 'لأنه خبر', 0),
(33, 'لأنه اسم فاعل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً في إدغام ''بيت طائفة'' للسوسي؟ (سؤال 2)', 9);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(34, 'وجه واحد', 1),
(34, 'وجهان', 0),
(34, 'ثلاثة أوجه', 0),
(34, 'امتناع الإدغام', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي العلة في منع إدغام ''واسعٌ عليم'' عند السوسي؟ (سؤال 3)', 9);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(35, 'لأنه منون', 1),
(35, 'لأن الحرف الأول مشدد', 0),
(35, 'لأنه خبر', 0),
(35, 'لأنه اسم فاعل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً في إدغام ''بيت طائفة'' للسوسي؟ (سؤال 4)', 9);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(36, 'وجه واحد', 1),
(36, 'وجهان', 0),
(36, 'ثلاثة أوجه', 0),
(36, 'امتناع الإدغام', 0);


-- Video 10: إدغام الحرفين المتقاربين فى كلمة و فى كلمتين ج٢
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي العلة في منع إدغام ''واسعٌ عليم'' عند السوسي؟ (سؤال 1)', 10);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(37, 'لأنه منون', 1),
(37, 'لأن الحرف الأول مشدد', 0),
(37, 'لأنه خبر', 0),
(37, 'لأنه اسم فاعل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً في إدغام ''بيت طائفة'' للسوسي؟ (سؤال 2)', 10);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(38, 'وجه واحد', 1),
(38, 'وجهان', 0),
(38, 'ثلاثة أوجه', 0),
(38, 'امتناع الإدغام', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي العلة في منع إدغام ''واسعٌ عليم'' عند السوسي؟ (سؤال 3)', 10);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(39, 'لأنه منون', 1),
(39, 'لأن الحرف الأول مشدد', 0),
(39, 'لأنه خبر', 0),
(39, 'لأنه اسم فاعل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً في إدغام ''بيت طائفة'' للسوسي؟ (سؤال 4)', 10);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(40, 'وجه واحد', 1),
(40, 'وجهان', 0),
(40, 'ثلاثة أوجه', 0),
(40, 'امتناع الإدغام', 0);


-- Video 11: باب هاء الكناية
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 11);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(41, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(41, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(41, 'بضم الزاي والفاء وواو مفتوحة', 0),
(41, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 11);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(42, 'نافع', 0),
(42, 'أبو عمرو', 0),
(42, 'الكوفيون وابن عامر', 1),
(42, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 11);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(43, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(43, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(43, 'بضم الزاي والفاء وواو مفتوحة', 0),
(43, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 11);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(44, 'نافع', 0),
(44, 'أبو عمرو', 0),
(44, 'الكوفيون وابن عامر', 1),
(44, 'ابن كثير', 0);


-- Video 12: باب المد و القصر ج١
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 12);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(45, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(45, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(45, 'بضم الزاي والفاء وواو مفتوحة', 0),
(45, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 12);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(46, 'نافع', 0),
(46, 'أبو عمرو', 0),
(46, 'الكوفيون وابن عامر', 1),
(46, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 12);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(47, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(47, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(47, 'بضم الزاي والفاء وواو مفتوحة', 0),
(47, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 12);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(48, 'نافع', 0),
(48, 'أبو عمرو', 0),
(48, 'الكوفيون وابن عامر', 1),
(48, 'ابن كثير', 0);


-- Video 13: باب المد و القصر ج2
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 13);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(49, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(49, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(49, 'بضم الزاي والفاء وواو مفتوحة', 0),
(49, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 13);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(50, 'نافع', 0),
(50, 'أبو عمرو', 0),
(50, 'الكوفيون وابن عامر', 1),
(50, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 13);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(51, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(51, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(51, 'بضم الزاي والفاء وواو مفتوحة', 0),
(51, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 13);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(52, 'نافع', 0),
(52, 'أبو عمرو', 0),
(52, 'الكوفيون وابن عامر', 1),
(52, 'ابن كثير', 0);


-- Video 14: باب الهمزتين من كلمة
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 14);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(53, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(53, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(53, 'بضم الزاي والفاء وواو مفتوحة', 0),
(53, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 14);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(54, 'نافع', 0),
(54, 'أبو عمرو', 0),
(54, 'الكوفيون وابن عامر', 1),
(54, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 14);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(55, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(55, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(55, 'بضم الزاي والفاء وواو مفتوحة', 0),
(55, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 14);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(56, 'نافع', 0),
(56, 'أبو عمرو', 0),
(56, 'الكوفيون وابن عامر', 1),
(56, 'ابن كثير', 0);


-- Video 15: باب الهمزتين من كلمتين
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 15);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(57, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(57, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(57, 'بضم الزاي والفاء وواو مفتوحة', 0),
(57, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 15);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(58, 'نافع', 0),
(58, 'أبو عمرو', 0),
(58, 'الكوفيون وابن عامر', 1),
(58, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 15);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(59, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(59, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(59, 'بضم الزاي والفاء وواو مفتوحة', 0),
(59, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 15);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(60, 'نافع', 0),
(60, 'أبو عمرو', 0),
(60, 'الكوفيون وابن عامر', 1),
(60, 'ابن كثير', 0);


-- Video 16: باب الهمز المفرد
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 16);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(61, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(61, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(61, 'بضم الزاي والفاء وواو مفتوحة', 0),
(61, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 16);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(62, 'نافع', 0),
(62, 'أبو عمرو', 0),
(62, 'الكوفيون وابن عامر', 1),
(62, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 16);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(63, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(63, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(63, 'بضم الزاي والفاء وواو مفتوحة', 0),
(63, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 16);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(64, 'نافع', 0),
(64, 'أبو عمرو', 0),
(64, 'الكوفيون وابن عامر', 1),
(64, 'ابن كثير', 0);


-- Video 17: نقل حركة الهمزة إلى الساكن قبلها
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 17);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(65, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(65, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(65, 'بضم الزاي والفاء وواو مفتوحة', 0),
(65, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 17);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(66, 'نافع', 0),
(66, 'أبو عمرو', 0),
(66, 'الكوفيون وابن عامر', 1),
(66, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 17);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(67, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(67, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(67, 'بضم الزاي والفاء وواو مفتوحة', 0),
(67, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 17);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(68, 'نافع', 0),
(68, 'أبو عمرو', 0),
(68, 'الكوفيون وابن عامر', 1),
(68, 'ابن كثير', 0);


-- Video 18: تأصيل وقف حمزة و هشام على الهمز
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 18);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(69, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(69, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(69, 'بضم الزاي والفاء وواو مفتوحة', 0),
(69, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 18);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(70, 'نافع', 0),
(70, 'أبو عمرو', 0),
(70, 'الكوفيون وابن عامر', 1),
(70, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 18);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(71, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(71, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(71, 'بضم الزاي والفاء وواو مفتوحة', 0),
(71, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 18);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(72, 'نافع', 0),
(72, 'أبو عمرو', 0),
(72, 'الكوفيون وابن عامر', 1),
(72, 'ابن كثير', 0);


-- Video 19: باب وقف حمزة و هشام على الهمز
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 19);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(73, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(73, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(73, 'بضم الزاي والفاء وواو مفتوحة', 0),
(73, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 19);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(74, 'نافع', 0),
(74, 'أبو عمرو', 0),
(74, 'الكوفيون وابن عامر', 1),
(74, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 19);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(75, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(75, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(75, 'بضم الزاي والفاء وواو مفتوحة', 0),
(75, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 19);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(76, 'نافع', 0),
(76, 'أبو عمرو', 0),
(76, 'الكوفيون وابن عامر', 1),
(76, 'ابن كثير', 0);


-- Video 20: باب الإظهار و الإدغام
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي العلة في منع إدغام ''واسعٌ عليم'' عند السوسي؟ (سؤال 1)', 20);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(77, 'لأنه منون', 1),
(77, 'لأن الحرف الأول مشدد', 0),
(77, 'لأنه خبر', 0),
(77, 'لأنه اسم فاعل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً في إدغام ''بيت طائفة'' للسوسي؟ (سؤال 2)', 20);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(78, 'وجه واحد', 1),
(78, 'وجهان', 0),
(78, 'ثلاثة أوجه', 0),
(78, 'امتناع الإدغام', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي العلة في منع إدغام ''واسعٌ عليم'' عند السوسي؟ (سؤال 3)', 20);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(79, 'لأنه منون', 1),
(79, 'لأن الحرف الأول مشدد', 0),
(79, 'لأنه خبر', 0),
(79, 'لأنه اسم فاعل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً في إدغام ''بيت طائفة'' للسوسي؟ (سؤال 4)', 20);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(80, 'وجه واحد', 1),
(80, 'وجهان', 0),
(80, 'ثلاثة أوجه', 0),
(80, 'امتناع الإدغام', 0);


-- Video 21: حروف قربت مخارجها و النون الساكنة والتنوين
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 21);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(81, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(81, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(81, 'بضم الزاي والفاء وواو مفتوحة', 0),
(81, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 21);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(82, 'نافع', 0),
(82, 'أبو عمرو', 0),
(82, 'الكوفيون وابن عامر', 1),
(82, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 21);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(83, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(83, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(83, 'بضم الزاي والفاء وواو مفتوحة', 0),
(83, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 21);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(84, 'نافع', 0),
(84, 'أبو عمرو', 0),
(84, 'الكوفيون وابن عامر', 1),
(84, 'ابن كثير', 0);


-- Video 22: الفتح و الإمالة و بين اللفظين ج١
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 22);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(85, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(85, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(85, 'بضم الزاي والفاء وواو مفتوحة', 0),
(85, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 22);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(86, 'نافع', 0),
(86, 'أبو عمرو', 0),
(86, 'الكوفيون وابن عامر', 1),
(86, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 22);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(87, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(87, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(87, 'بضم الزاي والفاء وواو مفتوحة', 0),
(87, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 22);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(88, 'نافع', 0),
(88, 'أبو عمرو', 0),
(88, 'الكوفيون وابن عامر', 1),
(88, 'ابن كثير', 0);


-- Video 23: الفتح و الإمالة و بين اللفظين ج٢
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 23);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(89, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(89, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(89, 'بضم الزاي والفاء وواو مفتوحة', 0),
(89, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 23);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(90, 'نافع', 0),
(90, 'أبو عمرو', 0),
(90, 'الكوفيون وابن عامر', 1),
(90, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 23);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(91, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(91, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(91, 'بضم الزاي والفاء وواو مفتوحة', 0),
(91, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 23);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(92, 'نافع', 0),
(92, 'أبو عمرو', 0),
(92, 'الكوفيون وابن عامر', 1),
(92, 'ابن كثير', 0);


-- Video 24: الفتح و الإمالة و بين اللفظين ج٣
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 24);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(93, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(93, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(93, 'بضم الزاي والفاء وواو مفتوحة', 0),
(93, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 24);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(94, 'نافع', 0),
(94, 'أبو عمرو', 0),
(94, 'الكوفيون وابن عامر', 1),
(94, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 24);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(95, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(95, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(95, 'بضم الزاي والفاء وواو مفتوحة', 0),
(95, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 24);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(96, 'نافع', 0),
(96, 'أبو عمرو', 0),
(96, 'الكوفيون وابن عامر', 1),
(96, 'ابن كثير', 0);


-- Video 25: مذهب الكسائي في إمالة هاء التأنيث و ما قبلها عند الوقف
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 25);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(97, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(97, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(97, 'بضم الزاي والفاء وواو مفتوحة', 0),
(97, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 25);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(98, 'نافع', 0),
(98, 'أبو عمرو', 0),
(98, 'الكوفيون وابن عامر', 1),
(98, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 25);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(99, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(99, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(99, 'بضم الزاي والفاء وواو مفتوحة', 0),
(99, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 25);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(100, 'نافع', 0),
(100, 'أبو عمرو', 0),
(100, 'الكوفيون وابن عامر', 1),
(100, 'ابن كثير', 0);


-- Video 26: مذاهبهم فى الراءات
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 26);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(101, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(101, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(101, 'بضم الزاي والفاء وواو مفتوحة', 0),
(101, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 26);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(102, 'نافع', 0),
(102, 'أبو عمرو', 0),
(102, 'الكوفيون وابن عامر', 1),
(102, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 26);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(103, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(103, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(103, 'بضم الزاي والفاء وواو مفتوحة', 0),
(103, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 26);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(104, 'نافع', 0),
(104, 'أبو عمرو', 0),
(104, 'الكوفيون وابن عامر', 1),
(104, 'ابن كثير', 0);


-- Video 27: باب اللامات
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 27);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(105, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(105, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(105, 'بضم الزاي والفاء وواو مفتوحة', 0),
(105, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 27);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(106, 'نافع', 0),
(106, 'أبو عمرو', 0),
(106, 'الكوفيون وابن عامر', 1),
(106, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 27);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(107, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(107, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(107, 'بضم الزاي والفاء وواو مفتوحة', 0),
(107, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 27);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(108, 'نافع', 0),
(108, 'أبو عمرو', 0),
(108, 'الكوفيون وابن عامر', 1),
(108, 'ابن كثير', 0);


-- Video 28: الوقف على أواخر الكلم ج١
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 28);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(109, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(109, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(109, 'بضم الزاي والفاء وواو مفتوحة', 0),
(109, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 28);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(110, 'نافع', 0),
(110, 'أبو عمرو', 0),
(110, 'الكوفيون وابن عامر', 1),
(110, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 28);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(111, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(111, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(111, 'بضم الزاي والفاء وواو مفتوحة', 0),
(111, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 28);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(112, 'نافع', 0),
(112, 'أبو عمرو', 0),
(112, 'الكوفيون وابن عامر', 1),
(112, 'ابن كثير', 0);


-- Video 29: الوقف على أواخر الكلم ج2
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 29);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(113, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(113, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(113, 'بضم الزاي والفاء وواو مفتوحة', 0),
(113, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 29);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(114, 'نافع', 0),
(114, 'أبو عمرو', 0),
(114, 'الكوفيون وابن عامر', 1),
(114, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 29);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(115, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(115, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(115, 'بضم الزاي والفاء وواو مفتوحة', 0),
(115, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 29);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(116, 'نافع', 0),
(116, 'أبو عمرو', 0),
(116, 'الكوفيون وابن عامر', 1),
(116, 'ابن كثير', 0);


-- Video 30: ياءات الإضافة
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 30);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(117, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(117, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(117, 'بضم الزاي والفاء وواو مفتوحة', 0),
(117, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 30);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(118, 'نافع', 0),
(118, 'أبو عمرو', 0),
(118, 'الكوفيون وابن عامر', 1),
(118, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 30);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(119, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(119, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(119, 'بضم الزاي والفاء وواو مفتوحة', 0),
(119, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 30);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(120, 'نافع', 0),
(120, 'أبو عمرو', 0),
(120, 'الكوفيون وابن عامر', 1),
(120, 'ابن كثير', 0);


-- Video 31: ياءات الزوائد
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 31);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(121, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(121, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(121, 'بضم الزاي والفاء وواو مفتوحة', 0),
(121, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 31);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(122, 'نافع', 0),
(122, 'أبو عمرو', 0),
(122, 'الكوفيون وابن عامر', 1),
(122, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 31);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(123, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(123, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(123, 'بضم الزاي والفاء وواو مفتوحة', 0),
(123, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 31);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(124, 'نافع', 0),
(124, 'أبو عمرو', 0),
(124, 'الكوفيون وابن عامر', 1),
(124, 'ابن كثير', 0);


-- Video 32: فرش البقرة ج١
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 32);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(125, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(125, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(125, 'بضم الزاي والفاء وواو مفتوحة', 0),
(125, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 32);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(126, 'نافع', 0),
(126, 'أبو عمرو', 0),
(126, 'الكوفيون وابن عامر', 1),
(126, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 32);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(127, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(127, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(127, 'بضم الزاي والفاء وواو مفتوحة', 0),
(127, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 32);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(128, 'نافع', 0),
(128, 'أبو عمرو', 0),
(128, 'الكوفيون وابن عامر', 1),
(128, 'ابن كثير', 0);


-- Video 33: فرش البقرة ج٢
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 33);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(129, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(129, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(129, 'بضم الزاي والفاء وواو مفتوحة', 0),
(129, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 33);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(130, 'نافع', 0),
(130, 'أبو عمرو', 0),
(130, 'الكوفيون وابن عامر', 1),
(130, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 33);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(131, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(131, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(131, 'بضم الزاي والفاء وواو مفتوحة', 0),
(131, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 33);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(132, 'نافع', 0),
(132, 'أبو عمرو', 0),
(132, 'الكوفيون وابن عامر', 1),
(132, 'ابن كثير', 0);


-- Video 34: فرش البقرة ج3
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 34);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(133, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(133, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(133, 'بضم الزاي والفاء وواو مفتوحة', 0),
(133, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 34);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(134, 'نافع', 0),
(134, 'أبو عمرو', 0),
(134, 'الكوفيون وابن عامر', 1),
(134, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 34);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(135, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(135, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(135, 'بضم الزاي والفاء وواو مفتوحة', 0),
(135, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 34);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(136, 'نافع', 0),
(136, 'أبو عمرو', 0),
(136, 'الكوفيون وابن عامر', 1),
(136, 'ابن كثير', 0);


-- Video 35: فرش البقرة ج4
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 35);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(137, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(137, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(137, 'بضم الزاي والفاء وواو مفتوحة', 0),
(137, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 35);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(138, 'نافع', 0),
(138, 'أبو عمرو', 0),
(138, 'الكوفيون وابن عامر', 1),
(138, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 35);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(139, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(139, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(139, 'بضم الزاي والفاء وواو مفتوحة', 0),
(139, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 35);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(140, 'نافع', 0),
(140, 'أبو عمرو', 0),
(140, 'الكوفيون وابن عامر', 1),
(140, 'ابن كثير', 0);


-- Video 36: فرش البقرة ج5
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 36);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(141, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(141, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(141, 'بضم الزاي والفاء وواو مفتوحة', 0),
(141, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 36);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(142, 'نافع', 0),
(142, 'أبو عمرو', 0),
(142, 'الكوفيون وابن عامر', 1),
(142, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 36);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(143, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(143, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(143, 'بضم الزاي والفاء وواو مفتوحة', 0),
(143, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 36);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(144, 'نافع', 0),
(144, 'أبو عمرو', 0),
(144, 'الكوفيون وابن عامر', 1),
(144, 'ابن كثير', 0);


-- Video 37: فرش البقرة ج6
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 37);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(145, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(145, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(145, 'بضم الزاي والفاء وواو مفتوحة', 0),
(145, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 37);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(146, 'نافع', 0),
(146, 'أبو عمرو', 0),
(146, 'الكوفيون وابن عامر', 1),
(146, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 37);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(147, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(147, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(147, 'بضم الزاي والفاء وواو مفتوحة', 0),
(147, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 37);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(148, 'نافع', 0),
(148, 'أبو عمرو', 0),
(148, 'الكوفيون وابن عامر', 1),
(148, 'ابن كثير', 0);


-- Video 38: فرش البقرة ج7
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 38);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(149, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(149, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(149, 'بضم الزاي والفاء وواو مفتوحة', 0),
(149, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 38);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(150, 'نافع', 0),
(150, 'أبو عمرو', 0),
(150, 'الكوفيون وابن عامر', 1),
(150, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 38);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(151, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(151, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(151, 'بضم الزاي والفاء وواو مفتوحة', 0),
(151, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 38);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(152, 'نافع', 0),
(152, 'أبو عمرو', 0),
(152, 'الكوفيون وابن عامر', 1),
(152, 'ابن كثير', 0);


-- Video 39: فرش آل عمران ج١
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 39);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(153, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(153, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(153, 'بضم الزاي والفاء وواو مفتوحة', 0),
(153, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 39);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(154, 'نافع', 0),
(154, 'أبو عمرو', 0),
(154, 'الكوفيون وابن عامر', 1),
(154, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 39);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(155, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(155, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(155, 'بضم الزاي والفاء وواو مفتوحة', 0),
(155, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 39);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(156, 'نافع', 0),
(156, 'أبو عمرو', 0),
(156, 'الكوفيون وابن عامر', 1),
(156, 'ابن كثير', 0);


-- Video 40: آل عمران ج٢
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 40);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(157, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(157, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(157, 'بضم الزاي والفاء وواو مفتوحة', 0),
(157, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 40);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(158, 'نافع', 0),
(158, 'أبو عمرو', 0),
(158, 'الكوفيون وابن عامر', 1),
(158, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 40);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(159, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(159, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(159, 'بضم الزاي والفاء وواو مفتوحة', 0),
(159, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 40);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(160, 'نافع', 0),
(160, 'أبو عمرو', 0),
(160, 'الكوفيون وابن عامر', 1),
(160, 'ابن كثير', 0);


-- Video 41: آل عمران ج3
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 41);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(161, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(161, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(161, 'بضم الزاي والفاء وواو مفتوحة', 0),
(161, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 41);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(162, 'نافع', 0),
(162, 'أبو عمرو', 0),
(162, 'الكوفيون وابن عامر', 1),
(162, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 41);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(163, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(163, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(163, 'بضم الزاي والفاء وواو مفتوحة', 0),
(163, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 41);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(164, 'نافع', 0),
(164, 'أبو عمرو', 0),
(164, 'الكوفيون وابن عامر', 1),
(164, 'ابن كثير', 0);


-- Video 42: النساء ج١
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 42);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(165, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(165, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(165, 'بضم الزاي والفاء وواو مفتوحة', 0),
(165, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 42);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(166, 'نافع', 0),
(166, 'أبو عمرو', 0),
(166, 'الكوفيون وابن عامر', 1),
(166, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 42);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(167, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(167, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(167, 'بضم الزاي والفاء وواو مفتوحة', 0),
(167, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 42);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(168, 'نافع', 0),
(168, 'أبو عمرو', 0),
(168, 'الكوفيون وابن عامر', 1),
(168, 'ابن كثير', 0);


-- Video 43: النساء ج٢
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 43);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(169, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(169, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(169, 'بضم الزاي والفاء وواو مفتوحة', 0),
(169, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 43);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(170, 'نافع', 0),
(170, 'أبو عمرو', 0),
(170, 'الكوفيون وابن عامر', 1),
(170, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 43);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(171, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(171, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(171, 'بضم الزاي والفاء وواو مفتوحة', 0),
(171, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 43);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(172, 'نافع', 0),
(172, 'أبو عمرو', 0),
(172, 'الكوفيون وابن عامر', 1),
(172, 'ابن كثير', 0);


-- Video 44: المائدة
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 44);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(173, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(173, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(173, 'بضم الزاي والفاء وواو مفتوحة', 0),
(173, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 44);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(174, 'نافع', 0),
(174, 'أبو عمرو', 0),
(174, 'الكوفيون وابن عامر', 1),
(174, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 44);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(175, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(175, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(175, 'بضم الزاي والفاء وواو مفتوحة', 0),
(175, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 44);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(176, 'نافع', 0),
(176, 'أبو عمرو', 0),
(176, 'الكوفيون وابن عامر', 1),
(176, 'ابن كثير', 0);


-- Video 45: الأنعام ج١
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 45);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(177, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(177, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(177, 'بضم الزاي والفاء وواو مفتوحة', 0),
(177, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 45);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(178, 'نافع', 0),
(178, 'أبو عمرو', 0),
(178, 'الكوفيون وابن عامر', 1),
(178, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 45);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(179, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(179, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(179, 'بضم الزاي والفاء وواو مفتوحة', 0),
(179, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 45);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(180, 'نافع', 0),
(180, 'أبو عمرو', 0),
(180, 'الكوفيون وابن عامر', 1),
(180, 'ابن كثير', 0);


-- Video 46: الأنعام ج2
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 46);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(181, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(181, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(181, 'بضم الزاي والفاء وواو مفتوحة', 0),
(181, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 46);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(182, 'نافع', 0),
(182, 'أبو عمرو', 0),
(182, 'الكوفيون وابن عامر', 1),
(182, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 46);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(183, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(183, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(183, 'بضم الزاي والفاء وواو مفتوحة', 0),
(183, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 46);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(184, 'نافع', 0),
(184, 'أبو عمرو', 0),
(184, 'الكوفيون وابن عامر', 1),
(184, 'ابن كثير', 0);


-- Video 47: الأنعام ج3
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 47);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(185, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(185, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(185, 'بضم الزاي والفاء وواو مفتوحة', 0),
(185, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 47);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(186, 'نافع', 0),
(186, 'أبو عمرو', 0),
(186, 'الكوفيون وابن عامر', 1),
(186, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 47);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(187, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(187, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(187, 'بضم الزاي والفاء وواو مفتوحة', 0),
(187, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 47);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(188, 'نافع', 0),
(188, 'أبو عمرو', 0),
(188, 'الكوفيون وابن عامر', 1),
(188, 'ابن كثير', 0);


-- Video 48: الأعراف ج١
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 48);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(189, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(189, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(189, 'بضم الزاي والفاء وواو مفتوحة', 0),
(189, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 48);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(190, 'نافع', 0),
(190, 'أبو عمرو', 0),
(190, 'الكوفيون وابن عامر', 1),
(190, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 48);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(191, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(191, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(191, 'بضم الزاي والفاء وواو مفتوحة', 0),
(191, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 48);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(192, 'نافع', 0),
(192, 'أبو عمرو', 0),
(192, 'الكوفيون وابن عامر', 1),
(192, 'ابن كثير', 0);


-- Video 49: الأعراف ج2
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 49);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(193, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(193, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(193, 'بضم الزاي والفاء وواو مفتوحة', 0),
(193, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 49);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(194, 'نافع', 0),
(194, 'أبو عمرو', 0),
(194, 'الكوفيون وابن عامر', 1),
(194, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 49);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(195, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(195, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(195, 'بضم الزاي والفاء وواو مفتوحة', 0),
(195, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 49);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(196, 'نافع', 0),
(196, 'أبو عمرو', 0),
(196, 'الكوفيون وابن عامر', 1),
(196, 'ابن كثير', 0);


-- Video 50: الأعراف ج3
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 50);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(197, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(197, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(197, 'بضم الزاي والفاء وواو مفتوحة', 0),
(197, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 50);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(198, 'نافع', 0),
(198, 'أبو عمرو', 0),
(198, 'الكوفيون وابن عامر', 1),
(198, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 50);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(199, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(199, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(199, 'بضم الزاي والفاء وواو مفتوحة', 0),
(199, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 50);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(200, 'نافع', 0),
(200, 'أبو عمرو', 0),
(200, 'الكوفيون وابن عامر', 1),
(200, 'ابن كثير', 0);


-- Video 51: الأنفال
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 51);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(201, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(201, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(201, 'بضم الزاي والفاء وواو مفتوحة', 0),
(201, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 51);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(202, 'نافع', 0),
(202, 'أبو عمرو', 0),
(202, 'الكوفيون وابن عامر', 1),
(202, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 51);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(203, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(203, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(203, 'بضم الزاي والفاء وواو مفتوحة', 0),
(203, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 51);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(204, 'نافع', 0),
(204, 'أبو عمرو', 0),
(204, 'الكوفيون وابن عامر', 1),
(204, 'ابن كثير', 0);


-- Video 52: التوبة
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 52);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(205, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(205, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(205, 'بضم الزاي والفاء وواو مفتوحة', 0),
(205, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 52);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(206, 'نافع', 0),
(206, 'أبو عمرو', 0),
(206, 'الكوفيون وابن عامر', 1),
(206, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 52);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(207, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(207, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(207, 'بضم الزاي والفاء وواو مفتوحة', 0),
(207, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 52);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(208, 'نافع', 0),
(208, 'أبو عمرو', 0),
(208, 'الكوفيون وابن عامر', 1),
(208, 'ابن كثير', 0);


-- Video 53: يونس
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 53);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(209, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(209, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(209, 'بضم الزاي والفاء وواو مفتوحة', 0),
(209, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 53);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(210, 'نافع', 0),
(210, 'أبو عمرو', 0),
(210, 'الكوفيون وابن عامر', 1),
(210, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 53);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(211, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(211, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(211, 'بضم الزاي والفاء وواو مفتوحة', 0),
(211, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 53);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(212, 'نافع', 0),
(212, 'أبو عمرو', 0),
(212, 'الكوفيون وابن عامر', 1),
(212, 'ابن كثير', 0);


-- Video 54: هود
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 54);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(213, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(213, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(213, 'بضم الزاي والفاء وواو مفتوحة', 0),
(213, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 54);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(214, 'نافع', 0),
(214, 'أبو عمرو', 0),
(214, 'الكوفيون وابن عامر', 1),
(214, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 54);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(215, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(215, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(215, 'بضم الزاي والفاء وواو مفتوحة', 0),
(215, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 54);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(216, 'نافع', 0),
(216, 'أبو عمرو', 0),
(216, 'الكوفيون وابن عامر', 1),
(216, 'ابن كثير', 0);


-- Video 55: يوسف
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 55);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(217, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(217, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(217, 'بضم الزاي والفاء وواو مفتوحة', 0),
(217, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 55);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(218, 'نافع', 0),
(218, 'أبو عمرو', 0),
(218, 'الكوفيون وابن عامر', 1),
(218, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 55);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(219, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(219, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(219, 'بضم الزاي والفاء وواو مفتوحة', 0),
(219, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 55);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(220, 'نافع', 0),
(220, 'أبو عمرو', 0),
(220, 'الكوفيون وابن عامر', 1),
(220, 'ابن كثير', 0);


-- Video 56: الرعد
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 56);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(221, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(221, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(221, 'بضم الزاي والفاء وواو مفتوحة', 0),
(221, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 56);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(222, 'نافع', 0),
(222, 'أبو عمرو', 0),
(222, 'الكوفيون وابن عامر', 1),
(222, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 56);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(223, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(223, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(223, 'بضم الزاي والفاء وواو مفتوحة', 0),
(223, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 56);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(224, 'نافع', 0),
(224, 'أبو عمرو', 0),
(224, 'الكوفيون وابن عامر', 1),
(224, 'ابن كثير', 0);


-- Video 57: إبراهيم
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 57);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(225, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(225, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(225, 'بضم الزاي والفاء وواو مفتوحة', 0),
(225, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 57);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(226, 'نافع', 0),
(226, 'أبو عمرو', 0),
(226, 'الكوفيون وابن عامر', 1),
(226, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 57);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(227, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(227, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(227, 'بضم الزاي والفاء وواو مفتوحة', 0),
(227, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 57);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(228, 'نافع', 0),
(228, 'أبو عمرو', 0),
(228, 'الكوفيون وابن عامر', 1),
(228, 'ابن كثير', 0);


-- Video 58: الحجر
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 58);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(229, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(229, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(229, 'بضم الزاي والفاء وواو مفتوحة', 0),
(229, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 58);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(230, 'نافع', 0),
(230, 'أبو عمرو', 0),
(230, 'الكوفيون وابن عامر', 1),
(230, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 58);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(231, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(231, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(231, 'بضم الزاي والفاء وواو مفتوحة', 0),
(231, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 58);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(232, 'نافع', 0),
(232, 'أبو عمرو', 0),
(232, 'الكوفيون وابن عامر', 1),
(232, 'ابن كثير', 0);


-- Video 59: النحل
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 59);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(233, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(233, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(233, 'بضم الزاي والفاء وواو مفتوحة', 0),
(233, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 59);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(234, 'نافع', 0),
(234, 'أبو عمرو', 0),
(234, 'الكوفيون وابن عامر', 1),
(234, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 59);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(235, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(235, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(235, 'بضم الزاي والفاء وواو مفتوحة', 0),
(235, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 59);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(236, 'نافع', 0),
(236, 'أبو عمرو', 0),
(236, 'الكوفيون وابن عامر', 1),
(236, 'ابن كثير', 0);


-- Video 60: الاسراء
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 60);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(237, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(237, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(237, 'بضم الزاي والفاء وواو مفتوحة', 0),
(237, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 60);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(238, 'نافع', 0),
(238, 'أبو عمرو', 0),
(238, 'الكوفيون وابن عامر', 1),
(238, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 60);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(239, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(239, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(239, 'بضم الزاي والفاء وواو مفتوحة', 0),
(239, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 60);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(240, 'نافع', 0),
(240, 'أبو عمرو', 0),
(240, 'الكوفيون وابن عامر', 1),
(240, 'ابن كثير', 0);


-- Video 61: الكهف ج1
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 61);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(241, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(241, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(241, 'بضم الزاي والفاء وواو مفتوحة', 0),
(241, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 61);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(242, 'نافع', 0),
(242, 'أبو عمرو', 0),
(242, 'الكوفيون وابن عامر', 1),
(242, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 61);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(243, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(243, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(243, 'بضم الزاي والفاء وواو مفتوحة', 0),
(243, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 61);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(244, 'نافع', 0),
(244, 'أبو عمرو', 0),
(244, 'الكوفيون وابن عامر', 1),
(244, 'ابن كثير', 0);


-- Video 62: الكهف ج2
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 62);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(245, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(245, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(245, 'بضم الزاي والفاء وواو مفتوحة', 0),
(245, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 62);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(246, 'نافع', 0),
(246, 'أبو عمرو', 0),
(246, 'الكوفيون وابن عامر', 1),
(246, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 62);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(247, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(247, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(247, 'بضم الزاي والفاء وواو مفتوحة', 0),
(247, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 62);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(248, 'نافع', 0),
(248, 'أبو عمرو', 0),
(248, 'الكوفيون وابن عامر', 1),
(248, 'ابن كثير', 0);


-- Video 63: طه
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 63);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(249, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(249, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(249, 'بضم الزاي والفاء وواو مفتوحة', 0),
(249, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 63);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(250, 'نافع', 0),
(250, 'أبو عمرو', 0),
(250, 'الكوفيون وابن عامر', 1),
(250, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 63);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(251, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(251, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(251, 'بضم الزاي والفاء وواو مفتوحة', 0),
(251, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 63);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(252, 'نافع', 0),
(252, 'أبو عمرو', 0),
(252, 'الكوفيون وابن عامر', 1),
(252, 'ابن كثير', 0);


-- Video 64: الانبياء
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 64);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(253, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(253, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(253, 'بضم الزاي والفاء وواو مفتوحة', 0),
(253, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 64);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(254, 'نافع', 0),
(254, 'أبو عمرو', 0),
(254, 'الكوفيون وابن عامر', 1),
(254, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 64);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(255, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(255, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(255, 'بضم الزاي والفاء وواو مفتوحة', 0),
(255, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 64);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(256, 'نافع', 0),
(256, 'أبو عمرو', 0),
(256, 'الكوفيون وابن عامر', 1),
(256, 'ابن كثير', 0);


-- Video 65: الحج
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 65);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(257, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(257, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(257, 'بضم الزاي والفاء وواو مفتوحة', 0),
(257, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 65);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(258, 'نافع', 0),
(258, 'أبو عمرو', 0),
(258, 'الكوفيون وابن عامر', 1),
(258, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 65);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(259, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(259, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(259, 'بضم الزاي والفاء وواو مفتوحة', 0),
(259, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 65);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(260, 'نافع', 0),
(260, 'أبو عمرو', 0),
(260, 'الكوفيون وابن عامر', 1),
(260, 'ابن كثير', 0);


-- Video 66: المؤمنون
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 66);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(261, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(261, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(261, 'بضم الزاي والفاء وواو مفتوحة', 0),
(261, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 66);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(262, 'نافع', 0),
(262, 'أبو عمرو', 0),
(262, 'الكوفيون وابن عامر', 1),
(262, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 66);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(263, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(263, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(263, 'بضم الزاي والفاء وواو مفتوحة', 0),
(263, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 66);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(264, 'نافع', 0),
(264, 'أبو عمرو', 0),
(264, 'الكوفيون وابن عامر', 1),
(264, 'ابن كثير', 0);


-- Video 67: النور
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 67);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(265, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(265, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(265, 'بضم الزاي والفاء وواو مفتوحة', 0),
(265, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 67);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(266, 'نافع', 0),
(266, 'أبو عمرو', 0),
(266, 'الكوفيون وابن عامر', 1),
(266, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 67);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(267, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(267, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(267, 'بضم الزاي والفاء وواو مفتوحة', 0),
(267, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 67);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(268, 'نافع', 0),
(268, 'أبو عمرو', 0),
(268, 'الكوفيون وابن عامر', 1),
(268, 'ابن كثير', 0);


-- Video 68: الفرقان
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 68);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(269, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(269, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(269, 'بضم الزاي والفاء وواو مفتوحة', 0),
(269, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 68);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(270, 'نافع', 0),
(270, 'أبو عمرو', 0),
(270, 'الكوفيون وابن عامر', 1),
(270, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 68);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(271, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(271, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(271, 'بضم الزاي والفاء وواو مفتوحة', 0),
(271, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 68);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(272, 'نافع', 0),
(272, 'أبو عمرو', 0),
(272, 'الكوفيون وابن عامر', 1),
(272, 'ابن كثير', 0);


-- Video 69: الشعراء
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 69);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(273, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(273, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(273, 'بضم الزاي والفاء وواو مفتوحة', 0),
(273, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 69);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(274, 'نافع', 0),
(274, 'أبو عمرو', 0),
(274, 'الكوفيون وابن عامر', 1),
(274, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 69);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(275, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(275, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(275, 'بضم الزاي والفاء وواو مفتوحة', 0),
(275, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 69);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(276, 'نافع', 0),
(276, 'أبو عمرو', 0),
(276, 'الكوفيون وابن عامر', 1),
(276, 'ابن كثير', 0);


-- Video 70: النمل
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 70);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(277, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(277, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(277, 'بضم الزاي والفاء وواو مفتوحة', 0),
(277, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 70);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(278, 'نافع', 0),
(278, 'أبو عمرو', 0),
(278, 'الكوفيون وابن عامر', 1),
(278, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 70);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(279, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(279, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(279, 'بضم الزاي والفاء وواو مفتوحة', 0),
(279, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 70);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(280, 'نافع', 0),
(280, 'أبو عمرو', 0),
(280, 'الكوفيون وابن عامر', 1),
(280, 'ابن كثير', 0);


-- Video 71: القصص
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 71);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(281, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(281, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(281, 'بضم الزاي والفاء وواو مفتوحة', 0),
(281, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 71);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(282, 'نافع', 0),
(282, 'أبو عمرو', 0),
(282, 'الكوفيون وابن عامر', 1),
(282, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 71);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(283, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(283, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(283, 'بضم الزاي والفاء وواو مفتوحة', 0),
(283, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 71);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(284, 'نافع', 0),
(284, 'أبو عمرو', 0),
(284, 'الكوفيون وابن عامر', 1),
(284, 'ابن كثير', 0);


-- Video 72: العنكبوت
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 72);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(285, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(285, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(285, 'بضم الزاي والفاء وواو مفتوحة', 0),
(285, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 72);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(286, 'نافع', 0),
(286, 'أبو عمرو', 0),
(286, 'الكوفيون وابن عامر', 1),
(286, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 72);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(287, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(287, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(287, 'بضم الزاي والفاء وواو مفتوحة', 0),
(287, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 72);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(288, 'نافع', 0),
(288, 'أبو عمرو', 0),
(288, 'الكوفيون وابن عامر', 1),
(288, 'ابن كثير', 0);


-- Video 73: من الروم الى السبا
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 73);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(289, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(289, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(289, 'بضم الزاي والفاء وواو مفتوحة', 0),
(289, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 73);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(290, 'نافع', 0),
(290, 'أبو عمرو', 0),
(290, 'الكوفيون وابن عامر', 1),
(290, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 73);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(291, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(291, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(291, 'بضم الزاي والفاء وواو مفتوحة', 0),
(291, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 73);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(292, 'نافع', 0),
(292, 'أبو عمرو', 0),
(292, 'الكوفيون وابن عامر', 1),
(292, 'ابن كثير', 0);


-- Video 74: الاحزاب
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 74);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(293, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(293, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(293, 'بضم الزاي والفاء وواو مفتوحة', 0),
(293, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 74);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(294, 'نافع', 0),
(294, 'أبو عمرو', 0),
(294, 'الكوفيون وابن عامر', 1),
(294, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 74);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(295, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(295, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(295, 'بضم الزاي والفاء وواو مفتوحة', 0),
(295, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 74);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(296, 'نافع', 0),
(296, 'أبو عمرو', 0),
(296, 'الكوفيون وابن عامر', 1),
(296, 'ابن كثير', 0);


-- Video 75: سبا وفاطر
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 75);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(297, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(297, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(297, 'بضم الزاي والفاء وواو مفتوحة', 0),
(297, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 75);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(298, 'نافع', 0),
(298, 'أبو عمرو', 0),
(298, 'الكوفيون وابن عامر', 1),
(298, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 75);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(299, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(299, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(299, 'بضم الزاي والفاء وواو مفتوحة', 0),
(299, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 75);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(300, 'نافع', 0),
(300, 'أبو عمرو', 0),
(300, 'الكوفيون وابن عامر', 1),
(300, 'ابن كثير', 0);


-- Video 76: يس
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 76);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(301, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(301, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(301, 'بضم الزاي والفاء وواو مفتوحة', 0),
(301, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 76);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(302, 'نافع', 0),
(302, 'أبو عمرو', 0),
(302, 'الكوفيون وابن عامر', 1),
(302, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 76);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(303, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(303, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(303, 'بضم الزاي والفاء وواو مفتوحة', 0),
(303, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 76);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(304, 'نافع', 0),
(304, 'أبو عمرو', 0),
(304, 'الكوفيون وابن عامر', 1),
(304, 'ابن كثير', 0);


-- Video 77: الصافات
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 77);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(305, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(305, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(305, 'بضم الزاي والفاء وواو مفتوحة', 0),
(305, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 77);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(306, 'نافع', 0),
(306, 'أبو عمرو', 0),
(306, 'الكوفيون وابن عامر', 1),
(306, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 77);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(307, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(307, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(307, 'بضم الزاي والفاء وواو مفتوحة', 0),
(307, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 77);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(308, 'نافع', 0),
(308, 'أبو عمرو', 0),
(308, 'الكوفيون وابن عامر', 1),
(308, 'ابن كثير', 0);


-- Video 78: ص
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 78);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(309, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(309, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(309, 'بضم الزاي والفاء وواو مفتوحة', 0),
(309, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 78);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(310, 'نافع', 0),
(310, 'أبو عمرو', 0),
(310, 'الكوفيون وابن عامر', 1),
(310, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 78);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(311, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(311, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(311, 'بضم الزاي والفاء وواو مفتوحة', 0),
(311, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 78);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(312, 'نافع', 0),
(312, 'أبو عمرو', 0),
(312, 'الكوفيون وابن عامر', 1),
(312, 'ابن كثير', 0);


-- Video 79: الزمر
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 79);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(313, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(313, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(313, 'بضم الزاي والفاء وواو مفتوحة', 0),
(313, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 79);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(314, 'نافع', 0),
(314, 'أبو عمرو', 0),
(314, 'الكوفيون وابن عامر', 1),
(314, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 79);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(315, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(315, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(315, 'بضم الزاي والفاء وواو مفتوحة', 0),
(315, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 79);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(316, 'نافع', 0),
(316, 'أبو عمرو', 0),
(316, 'الكوفيون وابن عامر', 1),
(316, 'ابن كثير', 0);


-- Video 80: غافر
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 80);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(317, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(317, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(317, 'بضم الزاي والفاء وواو مفتوحة', 0),
(317, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 80);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(318, 'نافع', 0),
(318, 'أبو عمرو', 0),
(318, 'الكوفيون وابن عامر', 1),
(318, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 80);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(319, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(319, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(319, 'بضم الزاي والفاء وواو مفتوحة', 0),
(319, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 80);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(320, 'نافع', 0),
(320, 'أبو عمرو', 0),
(320, 'الكوفيون وابن عامر', 1),
(320, 'ابن كثير', 0);


-- Video 81: فصلت
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 81);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(321, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(321, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(321, 'بضم الزاي والفاء وواو مفتوحة', 0),
(321, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 81);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(322, 'نافع', 0),
(322, 'أبو عمرو', 0),
(322, 'الكوفيون وابن عامر', 1),
(322, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 81);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(323, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(323, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(323, 'بضم الزاي والفاء وواو مفتوحة', 0),
(323, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 81);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(324, 'نافع', 0),
(324, 'أبو عمرو', 0),
(324, 'الكوفيون وابن عامر', 1),
(324, 'ابن كثير', 0);


-- Video 82: الشورى-الزخرف- الدخان
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 1)', 82);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(325, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(325, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(325, 'بضم الزاي والفاء وواو مفتوحة', 0),
(325, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 2)', 82);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(326, 'نافع', 0),
(326, 'أبو عمرو', 0),
(326, 'الكوفيون وابن عامر', 1),
(326, 'ابن كثير', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ ابن كثير لفظ ''هزؤا'' و ''كفؤا'' حيث وردت؟ (سؤال 3)', 82);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(327, 'بضم الزاي والفاء وهمزة مفتوحة', 1),
(327, 'بسكون الزاي والفاء وهمزة مفتوحة', 0),
(327, 'بضم الزاي والفاء وواو مفتوحة', 0),
(327, 'بإبدال الهمزة ياءً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (يُخادعون الله) بفتح الياء وإسكان الخاء في البقرة؟ (سؤال 4)', 82);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(328, 'نافع', 0),
(328, 'أبو عمرو', 0),
(328, 'الكوفيون وابن عامر', 1),
(328, 'ابن كثير', 0);


-- ============================================================
-- PLAYLIST 2 (VideoID 83 - 114)
-- ============================================================

-- Video 83: شرح مقدمة متن الدرة
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: شرح مقدمة متن الدرة)', 83);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(329, 'الموافقة دائماً', 0),
(329, 'المخالفة فقط فيما نص عليه', 1),
(329, 'الاستقلال التام', 0),
(329, 'إعادة نظم الشاطبية', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الملحق بـ (نافع) في الدرة؟ (تطبيق على: شرح مقدمة متن الدرة)', 83);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(330, 'أبو جعفر', 1),
(330, 'يعقوب', 0),
(330, 'خلف العاشر', 0),
(330, 'أبو عمرو', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما رمز (يعقوب الحضرمي) في متن الدرة؟ (تطبيق على: شرح مقدمة متن الدرة)', 83);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(331, 'أبج', 0),
(331, 'دهز', 0),
(331, 'حطي', 1),
(331, 'كلم', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: شرح مقدمة متن الدرة)', 83);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(332, 'الموافقة دائماً', 0),
(332, 'المخالفة فقط فيما نص عليه', 1),
(332, 'الاستقلال التام', 0),
(332, 'إعادة نظم الشاطبية', 0);


-- Video 84: البسملة وأم القرآن (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: البسملة وأم القرآن (الدرة))', 84);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(333, 'الموافقة دائماً', 0),
(333, 'المخالفة فقط فيما نص عليه', 1),
(333, 'الاستقلال التام', 0),
(333, 'إعادة نظم الشاطبية', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الملحق بـ (نافع) في الدرة؟ (تطبيق على: البسملة وأم القرآن (الدرة))', 84);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(334, 'أبو جعفر', 1),
(334, 'يعقوب', 0),
(334, 'خلف العاشر', 0),
(334, 'أبو عمرو', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما رمز (يعقوب الحضرمي) في متن الدرة؟ (تطبيق على: البسملة وأم القرآن (الدرة))', 84);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(335, 'أبج', 0),
(335, 'دهز', 0),
(335, 'حطي', 1),
(335, 'كلم', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: البسملة وأم القرآن (الدرة))', 84);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(336, 'الموافقة دائماً', 0),
(336, 'المخالفة فقط فيما نص عليه', 1),
(336, 'الاستقلال التام', 0),
(336, 'إعادة نظم الشاطبية', 0);


-- Video 85: الإدغام الكبير (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: الإدغام الكبير (الدرة))', 85);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(337, 'الموافقة دائماً', 0),
(337, 'المخالفة فقط فيما نص عليه', 1),
(337, 'الاستقلال التام', 0),
(337, 'إعادة نظم الشاطبية', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الملحق بـ (نافع) في الدرة؟ (تطبيق على: الإدغام الكبير (الدرة))', 85);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(338, 'أبو جعفر', 1),
(338, 'يعقوب', 0),
(338, 'خلف العاشر', 0),
(338, 'أبو عمرو', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما رمز (يعقوب الحضرمي) في متن الدرة؟ (تطبيق على: الإدغام الكبير (الدرة))', 85);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(339, 'أبج', 0),
(339, 'دهز', 0),
(339, 'حطي', 1),
(339, 'كلم', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: الإدغام الكبير (الدرة))', 85);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(340, 'الموافقة دائماً', 0),
(340, 'المخالفة فقط فيما نص عليه', 1),
(340, 'الاستقلال التام', 0),
(340, 'إعادة نظم الشاطبية', 0);


-- Video 86: هاء الكناية (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: هاء الكناية (الدرة))', 86);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(341, 'بالصاد', 0),
(341, 'بالسين', 1),
(341, 'بالإشمام', 0),
(341, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: هاء الكناية (الدرة))', 86);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(342, 'أبو جعفر', 0),
(342, 'يعقوب', 0),
(342, 'خلف العاشر', 1),
(342, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: هاء الكناية (الدرة))', 86);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(343, 'يسكت ويوسط المنفصل', 0),
(343, 'لا يسكت ويوسط المنفصل', 1),
(343, 'يسكت ويشبع المنفصل', 0),
(343, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: هاء الكناية (الدرة))', 86);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(344, 'بالصاد', 0),
(344, 'بالسين', 1),
(344, 'بالإشمام', 0),
(344, 'بالإبدال', 0);


-- Video 87: المد والقصر والهمزتان من كلمة ومن كلمتين (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: المد والقصر والهمزتان من كلمة ومن كلمتين (الدرة))', 87);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(345, 'الموافقة دائماً', 0),
(345, 'المخالفة فقط فيما نص عليه', 1),
(345, 'الاستقلال التام', 0),
(345, 'إعادة نظم الشاطبية', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الملحق بـ (نافع) في الدرة؟ (تطبيق على: المد والقصر والهمزتان من كلمة ومن كلمتين (الدرة))', 87);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(346, 'أبو جعفر', 1),
(346, 'يعقوب', 0),
(346, 'خلف العاشر', 0),
(346, 'أبو عمرو', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما رمز (يعقوب الحضرمي) في متن الدرة؟ (تطبيق على: المد والقصر والهمزتان من كلمة ومن كلمتين (الدرة))', 87);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(347, 'أبج', 0),
(347, 'دهز', 0),
(347, 'حطي', 1),
(347, 'كلم', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: المد والقصر والهمزتان من كلمة ومن كلمتين (الدرة))', 87);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(348, 'الموافقة دائماً', 0),
(348, 'المخالفة فقط فيما نص عليه', 1),
(348, 'الاستقلال التام', 0),
(348, 'إعادة نظم الشاطبية', 0);


-- Video 88: الهمز المفرد (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: الهمز المفرد (الدرة))', 88);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(349, 'الموافقة دائماً', 0),
(349, 'المخالفة فقط فيما نص عليه', 1),
(349, 'الاستقلال التام', 0),
(349, 'إعادة نظم الشاطبية', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الملحق بـ (نافع) في الدرة؟ (تطبيق على: الهمز المفرد (الدرة))', 88);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(350, 'أبو جعفر', 1),
(350, 'يعقوب', 0),
(350, 'خلف العاشر', 0),
(350, 'أبو عمرو', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما رمز (يعقوب الحضرمي) في متن الدرة؟ (تطبيق على: الهمز المفرد (الدرة))', 88);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(351, 'أبج', 0),
(351, 'دهز', 0),
(351, 'حطي', 1),
(351, 'كلم', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: الهمز المفرد (الدرة))', 88);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(352, 'الموافقة دائماً', 0),
(352, 'المخالفة فقط فيما نص عليه', 1),
(352, 'الاستقلال التام', 0),
(352, 'إعادة نظم الشاطبية', 0);


-- Video 89: النقل والسكت والإدغام الصغير والنون الساكنة (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: النقل والسكت والإدغام الصغير والنون الساكنة (الدرة))', 89);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(353, 'الموافقة دائماً', 0),
(353, 'المخالفة فقط فيما نص عليه', 1),
(353, 'الاستقلال التام', 0),
(353, 'إعادة نظم الشاطبية', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الملحق بـ (نافع) في الدرة؟ (تطبيق على: النقل والسكت والإدغام الصغير والنون الساكنة (الدرة))', 89);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(354, 'أبو جعفر', 1),
(354, 'يعقوب', 0),
(354, 'خلف العاشر', 0),
(354, 'أبو عمرو', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما رمز (يعقوب الحضرمي) في متن الدرة؟ (تطبيق على: النقل والسكت والإدغام الصغير والنون الساكنة (الدرة))', 89);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(355, 'أبج', 0),
(355, 'دهز', 0),
(355, 'حطي', 1),
(355, 'كلم', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: النقل والسكت والإدغام الصغير والنون الساكنة (الدرة))', 89);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(356, 'الموافقة دائماً', 0),
(356, 'المخالفة فقط فيما نص عليه', 1),
(356, 'الاستقلال التام', 0),
(356, 'إعادة نظم الشاطبية', 0);


-- Video 90: الفتح والإمالة (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: الفتح والإمالة (الدرة))', 90);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(357, 'بالصاد', 0),
(357, 'بالسين', 1),
(357, 'بالإشمام', 0),
(357, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: الفتح والإمالة (الدرة))', 90);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(358, 'أبو جعفر', 0),
(358, 'يعقوب', 0),
(358, 'خلف العاشر', 1),
(358, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: الفتح والإمالة (الدرة))', 90);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(359, 'يسكت ويوسط المنفصل', 0),
(359, 'لا يسكت ويوسط المنفصل', 1),
(359, 'يسكت ويشبع المنفصل', 0),
(359, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: الفتح والإمالة (الدرة))', 90);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(360, 'بالصاد', 0),
(360, 'بالسين', 1),
(360, 'بالإشمام', 0),
(360, 'بالإبدال', 0);


-- Video 91: اللامات والراءات والوقف على المرسوم (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: اللامات والراءات والوقف على المرسوم (الدرة))', 91);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(361, 'بالصاد', 0),
(361, 'بالسين', 1),
(361, 'بالإشمام', 0),
(361, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: اللامات والراءات والوقف على المرسوم (الدرة))', 91);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(362, 'أبو جعفر', 0),
(362, 'يعقوب', 0),
(362, 'خلف العاشر', 1),
(362, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: اللامات والراءات والوقف على المرسوم (الدرة))', 91);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(363, 'يسكت ويوسط المنفصل', 0),
(363, 'لا يسكت ويوسط المنفصل', 1),
(363, 'يسكت ويشبع المنفصل', 0),
(363, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: اللامات والراءات والوقف على المرسوم (الدرة))', 91);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(364, 'بالصاد', 0),
(364, 'بالسين', 1),
(364, 'بالإشمام', 0),
(364, 'بالإبدال', 0);


-- Video 92: ياءات الإضافة (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: ياءات الإضافة (الدرة))', 92);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(365, 'الموافقة دائماً', 0),
(365, 'المخالفة فقط فيما نص عليه', 1),
(365, 'الاستقلال التام', 0),
(365, 'إعادة نظم الشاطبية', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الملحق بـ (نافع) في الدرة؟ (تطبيق على: ياءات الإضافة (الدرة))', 92);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(366, 'أبو جعفر', 1),
(366, 'يعقوب', 0),
(366, 'خلف العاشر', 0),
(366, 'أبو عمرو', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما رمز (يعقوب الحضرمي) في متن الدرة؟ (تطبيق على: ياءات الإضافة (الدرة))', 92);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(367, 'أبج', 0),
(367, 'دهز', 0),
(367, 'حطي', 1),
(367, 'كلم', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: ياءات الإضافة (الدرة))', 92);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(368, 'الموافقة دائماً', 0),
(368, 'المخالفة فقط فيما نص عليه', 1),
(368, 'الاستقلال التام', 0),
(368, 'إعادة نظم الشاطبية', 0);


-- Video 93: ياءات الزوائد (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: ياءات الزوائد (الدرة))', 93);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(369, 'الموافقة دائماً', 0),
(369, 'المخالفة فقط فيما نص عليه', 1),
(369, 'الاستقلال التام', 0),
(369, 'إعادة نظم الشاطبية', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من هو القارئ الملحق بـ (نافع) في الدرة؟ (تطبيق على: ياءات الزوائد (الدرة))', 93);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(370, 'أبو جعفر', 1),
(370, 'يعقوب', 0),
(370, 'خلف العاشر', 0),
(370, 'أبو عمرو', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما رمز (يعقوب الحضرمي) في متن الدرة؟ (تطبيق على: ياءات الزوائد (الدرة))', 93);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(371, 'أبج', 0),
(371, 'دهز', 0),
(371, 'حطي', 1),
(371, 'كلم', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هو منهج الإمام الملحق في متن الدرة بالنسبة لأصل الشاطبية؟ (تطبيق على: ياءات الزوائد (الدرة))', 93);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(372, 'الموافقة دائماً', 0),
(372, 'المخالفة فقط فيما نص عليه', 1),
(372, 'الاستقلال التام', 0),
(372, 'إعادة نظم الشاطبية', 0);


-- Video 94: فرش البقرة ج1 (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش البقرة ج1 (الدرة))', 94);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(373, 'بالصاد', 0),
(373, 'بالسين', 1),
(373, 'بالإشمام', 0),
(373, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش البقرة ج1 (الدرة))', 94);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(374, 'أبو جعفر', 0),
(374, 'يعقوب', 0),
(374, 'خلف العاشر', 1),
(374, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش البقرة ج1 (الدرة))', 94);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(375, 'يسكت ويوسط المنفصل', 0),
(375, 'لا يسكت ويوسط المنفصل', 1),
(375, 'يسكت ويشبع المنفصل', 0),
(375, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش البقرة ج1 (الدرة))', 94);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(376, 'بالصاد', 0),
(376, 'بالسين', 1),
(376, 'بالإشمام', 0),
(376, 'بالإبدال', 0);


-- Video 95: فرش البقرة ج2 (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش البقرة ج2 (الدرة))', 95);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(377, 'بالصاد', 0),
(377, 'بالسين', 1),
(377, 'بالإشمام', 0),
(377, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش البقرة ج2 (الدرة))', 95);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(378, 'أبو جعفر', 0),
(378, 'يعقوب', 0),
(378, 'خلف العاشر', 1),
(378, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش البقرة ج2 (الدرة))', 95);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(379, 'يسكت ويوسط المنفصل', 0),
(379, 'لا يسكت ويوسط المنفصل', 1),
(379, 'يسكت ويشبع المنفصل', 0),
(379, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش البقرة ج2 (الدرة))', 95);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(380, 'بالصاد', 0),
(380, 'بالسين', 1),
(380, 'بالإشمام', 0),
(380, 'بالإبدال', 0);


-- Video 96: فرش البقرة ج3 (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش البقرة ج3 (الدرة))', 96);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(381, 'بالصاد', 0),
(381, 'بالسين', 1),
(381, 'بالإشمام', 0),
(381, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش البقرة ج3 (الدرة))', 96);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(382, 'أبو جعفر', 0),
(382, 'يعقوب', 0),
(382, 'خلف العاشر', 1),
(382, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش البقرة ج3 (الدرة))', 96);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(383, 'يسكت ويوسط المنفصل', 0),
(383, 'لا يسكت ويوسط المنفصل', 1),
(383, 'يسكت ويشبع المنفصل', 0),
(383, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش البقرة ج3 (الدرة))', 96);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(384, 'بالصاد', 0),
(384, 'بالسين', 1),
(384, 'بالإشمام', 0),
(384, 'بالإبدال', 0);


-- Video 97: فرش آل عمران (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش آل عمران (الدرة))', 97);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(385, 'بالصاد', 0),
(385, 'بالسين', 1),
(385, 'بالإشمام', 0),
(385, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش آل عمران (الدرة))', 97);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(386, 'أبو جعفر', 0),
(386, 'يعقوب', 0),
(386, 'خلف العاشر', 1),
(386, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش آل عمران (الدرة))', 97);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(387, 'يسكت ويوسط المنفصل', 0),
(387, 'لا يسكت ويوسط المنفصل', 1),
(387, 'يسكت ويشبع المنفصل', 0),
(387, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش آل عمران (الدرة))', 97);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(388, 'بالصاد', 0),
(388, 'بالسين', 1),
(388, 'بالإشمام', 0),
(388, 'بالإبدال', 0);


-- Video 98: فرش النساء والمائدة (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش النساء والمائدة (الدرة))', 98);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(389, 'بالصاد', 0),
(389, 'بالسين', 1),
(389, 'بالإشمام', 0),
(389, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش النساء والمائدة (الدرة))', 98);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(390, 'أبو جعفر', 0),
(390, 'يعقوب', 0),
(390, 'خلف العاشر', 1),
(390, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش النساء والمائدة (الدرة))', 98);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(391, 'يسكت ويوسط المنفصل', 0),
(391, 'لا يسكت ويوسط المنفصل', 1),
(391, 'يسكت ويشبع المنفصل', 0),
(391, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش النساء والمائدة (الدرة))', 98);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(392, 'بالصاد', 0),
(392, 'بالسين', 1),
(392, 'بالإشمام', 0),
(392, 'بالإبدال', 0);


-- Video 99: تكملة فرش المائدة (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: تكملة فرش المائدة (الدرة))', 99);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(393, 'بالصاد', 0),
(393, 'بالسين', 1),
(393, 'بالإشمام', 0),
(393, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: تكملة فرش المائدة (الدرة))', 99);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(394, 'أبو جعفر', 0),
(394, 'يعقوب', 0),
(394, 'خلف العاشر', 1),
(394, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: تكملة فرش المائدة (الدرة))', 99);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(395, 'يسكت ويوسط المنفصل', 0),
(395, 'لا يسكت ويوسط المنفصل', 1),
(395, 'يسكت ويشبع المنفصل', 0),
(395, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: تكملة فرش المائدة (الدرة))', 99);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(396, 'بالصاد', 0),
(396, 'بالسين', 1),
(396, 'بالإشمام', 0),
(396, 'بالإبدال', 0);


-- Video 100: فرش الأنعام (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الأنعام (الدرة))', 100);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(397, 'بالصاد', 0),
(397, 'بالسين', 1),
(397, 'بالإشمام', 0),
(397, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش الأنعام (الدرة))', 100);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(398, 'أبو جعفر', 0),
(398, 'يعقوب', 0),
(398, 'خلف العاشر', 1),
(398, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش الأنعام (الدرة))', 100);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(399, 'يسكت ويوسط المنفصل', 0),
(399, 'لا يسكت ويوسط المنفصل', 1),
(399, 'يسكت ويشبع المنفصل', 0),
(399, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الأنعام (الدرة))', 100);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(400, 'بالصاد', 0),
(400, 'بالسين', 1),
(400, 'بالإشمام', 0),
(400, 'بالإبدال', 0);


-- Video 101: فرش الأعراف والأنفال (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الأعراف والأنفال (الدرة))', 101);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(401, 'بالصاد', 0),
(401, 'بالسين', 1),
(401, 'بالإشمام', 0),
(401, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش الأعراف والأنفال (الدرة))', 101);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(402, 'أبو جعفر', 0),
(402, 'يعقوب', 0),
(402, 'خلف العاشر', 1),
(402, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش الأعراف والأنفال (الدرة))', 101);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(403, 'يسكت ويوسط المنفصل', 0),
(403, 'لا يسكت ويوسط المنفصل', 1),
(403, 'يسكت ويشبع المنفصل', 0),
(403, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الأعراف والأنفال (الدرة))', 101);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(404, 'بالصاد', 0),
(404, 'بالسين', 1),
(404, 'بالإشمام', 0),
(404, 'بالإبدال', 0);


-- Video 102: فرش التوبة ويونس وهود (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش التوبة ويونس وهود (الدرة))', 102);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(405, 'بالصاد', 0),
(405, 'بالسين', 1),
(405, 'بالإشمام', 0),
(405, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش التوبة ويونس وهود (الدرة))', 102);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(406, 'أبو جعفر', 0),
(406, 'يعقوب', 0),
(406, 'خلف العاشر', 1),
(406, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش التوبة ويونس وهود (الدرة))', 102);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(407, 'يسكت ويوسط المنفصل', 0),
(407, 'لا يسكت ويوسط المنفصل', 1),
(407, 'يسكت ويشبع المنفصل', 0),
(407, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش التوبة ويونس وهود (الدرة))', 102);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(408, 'بالصاد', 0),
(408, 'بالسين', 1),
(408, 'بالإشمام', 0),
(408, 'بالإبدال', 0);


-- Video 103: فرش يوسف (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش يوسف (الدرة))', 103);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(409, 'بالصاد', 0),
(409, 'بالسين', 1),
(409, 'بالإشمام', 0),
(409, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش يوسف (الدرة))', 103);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(410, 'أبو جعفر', 0),
(410, 'يعقوب', 0),
(410, 'خلف العاشر', 1),
(410, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش يوسف (الدرة))', 103);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(411, 'يسكت ويوسط المنفصل', 0),
(411, 'لا يسكت ويوسط المنفصل', 1),
(411, 'يسكت ويشبع المنفصل', 0),
(411, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش يوسف (الدرة))', 103);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(412, 'بالصاد', 0),
(412, 'بالسين', 1),
(412, 'بالإشمام', 0),
(412, 'بالإبدال', 0);


-- Video 104: فرش إبراهيم (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش إبراهيم (الدرة))', 104);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(413, 'بالصاد', 0),
(413, 'بالسين', 1),
(413, 'بالإشمام', 0),
(413, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش إبراهيم (الدرة))', 104);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(414, 'أبو جعفر', 0),
(414, 'يعقوب', 0),
(414, 'خلف العاشر', 1),
(414, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش إبراهيم (الدرة))', 104);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(415, 'يسكت ويوسط المنفصل', 0),
(415, 'لا يسكت ويوسط المنفصل', 1),
(415, 'يسكت ويشبع المنفصل', 0),
(415, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش إبراهيم (الدرة))', 104);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(416, 'بالصاد', 0),
(416, 'بالسين', 1),
(416, 'بالإشمام', 0),
(416, 'بالإبدال', 0);


-- Video 105: فرش الحجر والنحل (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الحجر والنحل (الدرة))', 105);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(417, 'بالصاد', 0),
(417, 'بالسين', 1),
(417, 'بالإشمام', 0),
(417, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش الحجر والنحل (الدرة))', 105);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(418, 'أبو جعفر', 0),
(418, 'يعقوب', 0),
(418, 'خلف العاشر', 1),
(418, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش الحجر والنحل (الدرة))', 105);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(419, 'يسكت ويوسط المنفصل', 0),
(419, 'لا يسكت ويوسط المنفصل', 1),
(419, 'يسكت ويشبع المنفصل', 0),
(419, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الحجر والنحل (الدرة))', 105);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(420, 'بالصاد', 0),
(420, 'بالسين', 1),
(420, 'بالإشمام', 0),
(420, 'بالإبدال', 0);


-- Video 106: فرش الإسراء (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الإسراء (الدرة))', 106);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(421, 'بالصاد', 0),
(421, 'بالسين', 1),
(421, 'بالإشمام', 0),
(421, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش الإسراء (الدرة))', 106);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(422, 'أبو جعفر', 0),
(422, 'يعقوب', 0),
(422, 'خلف العاشر', 1),
(422, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش الإسراء (الدرة))', 106);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(423, 'يسكت ويوسط المنفصل', 0),
(423, 'لا يسكت ويوسط المنفصل', 1),
(423, 'يسكت ويشبع المنفصل', 0),
(423, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الإسراء (الدرة))', 106);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(424, 'بالصاد', 0),
(424, 'بالسين', 1),
(424, 'بالإشمام', 0),
(424, 'بالإبدال', 0);


-- Video 107: فرش الكهف (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الكهف (الدرة))', 107);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(425, 'بالصاد', 0),
(425, 'بالسين', 1),
(425, 'بالإشمام', 0),
(425, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش الكهف (الدرة))', 107);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(426, 'أبو جعفر', 0),
(426, 'يعقوب', 0),
(426, 'خلف العاشر', 1),
(426, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش الكهف (الدرة))', 107);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(427, 'يسكت ويوسط المنفصل', 0),
(427, 'لا يسكت ويوسط المنفصل', 1),
(427, 'يسكت ويشبع المنفصل', 0),
(427, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الكهف (الدرة))', 107);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(428, 'بالصاد', 0),
(428, 'بالسين', 1),
(428, 'بالإشمام', 0),
(428, 'بالإبدال', 0);


-- Video 108: فرش مريم وطه (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش مريم وطه (الدرة))', 108);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(429, 'بالصاد', 0),
(429, 'بالسين', 1),
(429, 'بالإشمام', 0),
(429, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش مريم وطه (الدرة))', 108);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(430, 'أبو جعفر', 0),
(430, 'يعقوب', 0),
(430, 'خلف العاشر', 1),
(430, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش مريم وطه (الدرة))', 108);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(431, 'يسكت ويوسط المنفصل', 0),
(431, 'لا يسكت ويوسط المنفصل', 1),
(431, 'يسكت ويشبع المنفصل', 0),
(431, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش مريم وطه (الدرة))', 108);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(432, 'بالصاد', 0),
(432, 'بالسين', 1),
(432, 'بالإشمام', 0),
(432, 'بالإبدال', 0);


-- Video 109: فرش الأنبياء (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الأنبياء (الدرة))', 109);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(433, 'بالصاد', 0),
(433, 'بالسين', 1),
(433, 'بالإشمام', 0),
(433, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش الأنبياء (الدرة))', 109);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(434, 'أبو جعفر', 0),
(434, 'يعقوب', 0),
(434, 'خلف العاشر', 1),
(434, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش الأنبياء (الدرة))', 109);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(435, 'يسكت ويوسط المنفصل', 0),
(435, 'لا يسكت ويوسط المنفصل', 1),
(435, 'يسكت ويشبع المنفصل', 0),
(435, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الأنبياء (الدرة))', 109);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(436, 'بالصاد', 0),
(436, 'بالسين', 1),
(436, 'بالإشمام', 0),
(436, 'بالإبدال', 0);


-- Video 110: فرش الفرقان إلى الروم (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الفرقان إلى الروم (الدرة))', 110);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(437, 'بالصاد', 0),
(437, 'بالسين', 1),
(437, 'بالإشمام', 0),
(437, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش الفرقان إلى الروم (الدرة))', 110);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(438, 'أبو جعفر', 0),
(438, 'يعقوب', 0),
(438, 'خلف العاشر', 1),
(438, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش الفرقان إلى الروم (الدرة))', 110);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(439, 'يسكت ويوسط المنفصل', 0),
(439, 'لا يسكت ويوسط المنفصل', 1),
(439, 'يسكت ويشبع المنفصل', 0),
(439, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الفرقان إلى الروم (الدرة))', 110);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(440, 'بالصاد', 0),
(440, 'بالسين', 1),
(440, 'بالإشمام', 0),
(440, 'بالإبدال', 0);


-- Video 111: فرش الروم ولقمان والسجدة (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الروم ولقمان والسجدة (الدرة))', 111);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(441, 'بالصاد', 0),
(441, 'بالسين', 1),
(441, 'بالإشمام', 0),
(441, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش الروم ولقمان والسجدة (الدرة))', 111);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(442, 'أبو جعفر', 0),
(442, 'يعقوب', 0),
(442, 'خلف العاشر', 1),
(442, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش الروم ولقمان والسجدة (الدرة))', 111);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(443, 'يسكت ويوسط المنفصل', 0),
(443, 'لا يسكت ويوسط المنفصل', 1),
(443, 'يسكت ويشبع المنفصل', 0),
(443, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الروم ولقمان والسجدة (الدرة))', 111);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(444, 'بالصاد', 0),
(444, 'بالسين', 1),
(444, 'بالإشمام', 0),
(444, 'بالإبدال', 0);


-- Video 112: فرش الأحزاب وسبأ وفاطر (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الأحزاب وسبأ وفاطر (الدرة))', 112);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(445, 'بالصاد', 0),
(445, 'بالسين', 1),
(445, 'بالإشمام', 0),
(445, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش الأحزاب وسبأ وفاطر (الدرة))', 112);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(446, 'أبو جعفر', 0),
(446, 'يعقوب', 0),
(446, 'خلف العاشر', 1),
(446, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش الأحزاب وسبأ وفاطر (الدرة))', 112);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(447, 'يسكت ويوسط المنفصل', 0),
(447, 'لا يسكت ويوسط المنفصل', 1),
(447, 'يسكت ويشبع المنفصل', 0),
(447, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش الأحزاب وسبأ وفاطر (الدرة))', 112);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(448, 'بالصاد', 0),
(448, 'بالسين', 1),
(448, 'بالإشمام', 0),
(448, 'بالإبدال', 0);


-- Video 113: فرش يس والصافات (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش يس والصافات (الدرة))', 113);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(449, 'بالصاد', 0),
(449, 'بالسين', 1),
(449, 'بالإشمام', 0),
(449, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش يس والصافات (الدرة))', 113);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(450, 'أبو جعفر', 0),
(450, 'يعقوب', 0),
(450, 'خلف العاشر', 1),
(450, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش يس والصافات (الدرة))', 113);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(451, 'يسكت ويوسط المنفصل', 0),
(451, 'لا يسكت ويوسط المنفصل', 1),
(451, 'يسكت ويشبع المنفصل', 0),
(451, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش يس والصافات (الدرة))', 113);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(452, 'بالصاد', 0),
(452, 'بالسين', 1),
(452, 'بالإشمام', 0),
(452, 'بالإبدال', 0);


-- Video 114: فرش ص إلى فصلت (الدرة)
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش ص إلى فصلت (الدرة))', 114);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(453, 'بالصاد', 0),
(453, 'بالسين', 1),
(453, 'بالإشمام', 0),
(453, 'بالإبدال', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('من الذي قرأ (الصراط) بالسين في الدرة؟ (تطبيق على: فرش ص إلى فصلت (الدرة))', 114);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(454, 'أبو جعفر', 0),
(454, 'يعقوب', 0),
(454, 'خلف العاشر', 1),
(454, 'رئيس عن يعقوب', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما مذهب خلف العاشر في السكت على (أل) والمد المنفصل؟ (تطبيق على: فرش ص إلى فصلت (الدرة))', 114);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(455, 'يسكت ويوسط المنفصل', 0),
(455, 'لا يسكت ويوسط المنفصل', 1),
(455, 'يسكت ويشبع المنفصل', 0),
(455, 'لا يسكت ويقصر المنفصل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كيف قرأ أبو جعفر لفظ (بسطة) في سورة البقرة؟ (تطبيق على: فرش ص إلى فصلت (الدرة))', 114);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(456, 'بالصاد', 0),
(456, 'بالسين', 1),
(456, 'بالإشمام', 0),
(456, 'بالإبدال', 0);


-- ============================================================
-- PLAYLIST 3 (VideoID 115 - 126)
-- ============================================================

-- Video 115: تحريرات الشاطبية والدرة - 1 مقدمة
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 1 مقدمة)', 115);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(457, 'ترك السكت مع القصر والتوسط', 0),
(457, 'السكت مع التوسط فقط', 0),
(457, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(457, 'السكت مع القصر فقط', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً ليعقوب في هاء السكت في نحو (كتابيه) وصلاً؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 1 مقدمة)', 115);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(458, 'الحذف قولاً واحداً', 1),
(458, 'الإثبات قولاً واحداً', 0),
(458, 'الحذف والإثبات والمقدم الحذف', 0),
(458, 'الإثبات وصلاً والحذف وقفاً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما الوجه الممتنع عند اجتماع (البدل) مع (العارض للسكون) لورش؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 1 مقدمة)', 115);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(459, 'قصر البدل مع إشباع العارض', 0),
(459, 'توسط البدل مع قصر العارض', 1),
(459, 'إشباع البدل مع إشباع العارض', 0),
(459, 'قصر البدل مع قصر العارض', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 1 مقدمة)', 115);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(460, 'ترك السكت مع القصر والتوسط', 0),
(460, 'السكت مع التوسط فقط', 0),
(460, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(460, 'السكت مع القصر فقط', 0);


-- Video 116: تحريرات الشاطبية والدرة - 2 الإدغام الكبير
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 2 الإدغام الكبير)', 116);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(461, 'ترك السكت مع القصر والتوسط', 0),
(461, 'السكت مع التوسط فقط', 0),
(461, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(461, 'السكت مع القصر فقط', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً ليعقوب في هاء السكت في نحو (كتابيه) وصلاً؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 2 الإدغام الكبير)', 116);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(462, 'الحذف قولاً واحداً', 1),
(462, 'الإثبات قولاً واحداً', 0),
(462, 'الحذف والإثبات والمقدم الحذف', 0),
(462, 'الإثبات وصلاً والحذف وقفاً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما الوجه الممتنع عند اجتماع (البدل) مع (العارض للسكون) لورش؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 2 الإدغام الكبير)', 116);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(463, 'قصر البدل مع إشباع العارض', 0),
(463, 'توسط البدل مع قصر العارض', 1),
(463, 'إشباع البدل مع إشباع العارض', 0),
(463, 'قصر البدل مع قصر العارض', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 2 الإدغام الكبير)', 116);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(464, 'ترك السكت مع القصر والتوسط', 0),
(464, 'السكت مع التوسط فقط', 0),
(464, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(464, 'السكت مع القصر فقط', 0);


-- Video 117: تحريرات الشاطبية والدرة - 3 الاستعاذة.. صراط.. بين السورتين
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 3 الاستعاذة.. صراط.. بين السورتين)', 117);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(465, 'ترك السكت مع القصر والتوسط', 0),
(465, 'السكت مع التوسط فقط', 0),
(465, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(465, 'السكت مع القصر فقط', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً ليعقوب في هاء السكت في نحو (كتابيه) وصلاً؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 3 الاستعاذة.. صراط.. بين السورتين)', 117);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(466, 'الحذف قولاً واحداً', 1),
(466, 'الإثبات قولاً واحداً', 0),
(466, 'الحذف والإثبات والمقدم الحذف', 0),
(466, 'الإثبات وصلاً والحذف وقفاً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما الوجه الممتنع عند اجتماع (البدل) مع (العارض للسكون) لورش؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 3 الاستعاذة.. صراط.. بين السورتين)', 117);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(467, 'قصر البدل مع إشباع العارض', 0),
(467, 'توسط البدل مع قصر العارض', 1),
(467, 'إشباع البدل مع إشباع العارض', 0),
(467, 'قصر البدل مع قصر العارض', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 3 الاستعاذة.. صراط.. بين السورتين)', 117);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(468, 'ترك السكت مع القصر والتوسط', 0),
(468, 'السكت مع التوسط فقط', 0),
(468, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(468, 'السكت مع القصر فقط', 0);


-- Video 118: تحريرات الشاطبية والدرة - 4 حروف التهجي - السكت... وغيرها
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 4 حروف التهجي - السكت... وغيرها)', 118);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(469, 'ترك السكت مع القصر والتوسط', 0),
(469, 'السكت مع التوسط فقط', 0),
(469, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(469, 'السكت مع القصر فقط', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً ليعقوب في هاء السكت في نحو (كتابيه) وصلاً؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 4 حروف التهجي - السكت... وغيرها)', 118);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(470, 'الحذف قولاً واحداً', 1),
(470, 'الإثبات قولاً واحداً', 0),
(470, 'الحذف والإثبات والمقدم الحذف', 0),
(470, 'الإثبات وصلاً والحذف وقفاً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما الوجه الممتنع عند اجتماع (البدل) مع (العارض للسكون) لورش؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 4 حروف التهجي - السكت... وغيرها)', 118);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(471, 'قصر البدل مع إشباع العارض', 0),
(471, 'توسط البدل مع قصر العارض', 1),
(471, 'إشباع البدل مع إشباع العارض', 0),
(471, 'قصر البدل مع قصر العارض', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 4 حروف التهجي - السكت... وغيرها)', 118);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(472, 'ترك السكت مع القصر والتوسط', 0),
(472, 'السكت مع التوسط فقط', 0),
(472, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(472, 'السكت مع القصر فقط', 0);


-- Video 119: تحريرات الشاطبية والدرة - 5 مد البدل لورش
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي الأوجه الجائزة لورش في (مد البدل) مع (ذات الياء) من طريق الشاطبية؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 5 مد البدل لورش)', 119);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(473, 'قصر البدل مع الفتح، وتوسطه مع التقليل، وإشباعه مع الوجهين', 1),
(473, 'قصر البدل مع التقليل فقط', 0),
(473, 'إشباع البدل مع الفتح فقط', 0),
(473, 'توسط البدل مع الفتح والتقليل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما حكم اللام في لفظ (صلصال) لورش عند تحرير الأوجه؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 5 مد البدل لورش)', 119);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(474, 'التغليظ قولاً واحداً', 0),
(474, 'الترقيق قولاً واحداً', 1),
(474, 'الترقيق مع قصر البدل والتغليظ مع غيره', 0),
(474, 'التغليظ والترقيق والصحيح الترقيق', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي الأوجه الجائزة لورش في (مد البدل) مع (ذات الياء) من طريق الشاطبية؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 5 مد البدل لورش)', 119);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(475, 'قصر البدل مع الفتح، وتوسطه مع التقليل، وإشباعه مع الوجهين', 1),
(475, 'قصر البدل مع التقليل فقط', 0),
(475, 'إشباع البدل مع الفتح فقط', 0),
(475, 'توسط البدل مع الفتح والتقليل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما حكم اللام في لفظ (صلصال) لورش عند تحرير الأوجه؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 5 مد البدل لورش)', 119);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(476, 'التغليظ قولاً واحداً', 0),
(476, 'الترقيق قولاً واحداً', 1),
(476, 'الترقيق مع قصر البدل والتغليظ مع غيره', 0),
(476, 'التغليظ والترقيق والصحيح الترقيق', 0);


-- Video 120: تحريرات الشاطبية والدرة - 6 تحريرات ورش ج2
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي الأوجه الجائزة لورش في (مد البدل) مع (ذات الياء) من طريق الشاطبية؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 6 تحريرات ورش ج2)', 120);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(477, 'قصر البدل مع الفتح، وتوسطه مع التقليل، وإشباعه مع الوجهين', 1),
(477, 'قصر البدل مع التقليل فقط', 0),
(477, 'إشباع البدل مع الفتح فقط', 0),
(477, 'توسط البدل مع الفتح والتقليل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما حكم اللام في لفظ (صلصال) لورش عند تحرير الأوجه؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 6 تحريرات ورش ج2)', 120);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(478, 'التغليظ قولاً واحداً', 0),
(478, 'الترقيق قولاً واحداً', 1),
(478, 'الترقيق مع قصر البدل والتغليظ مع غيره', 0),
(478, 'التغليظ والترقيق والصحيح الترقيق', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي الأوجه الجائزة لورش في (مد البدل) مع (ذات الياء) من طريق الشاطبية؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 6 تحريرات ورش ج2)', 120);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(479, 'قصر البدل مع الفتح، وتوسطه مع التقليل، وإشباعه مع الوجهين', 1),
(479, 'قصر البدل مع التقليل فقط', 0),
(479, 'إشباع البدل مع الفتح فقط', 0),
(479, 'توسط البدل مع الفتح والتقليل', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما حكم اللام في لفظ (صلصال) لورش عند تحرير الأوجه؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 6 تحريرات ورش ج2)', 120);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(480, 'التغليظ قولاً واحداً', 0),
(480, 'الترقيق قولاً واحداً', 1),
(480, 'الترقيق مع قصر البدل والتغليظ مع غيره', 0),
(480, 'التغليظ والترقيق والصحيح الترقيق', 0);


-- Video 121: تحريرات الشاطبية والدرة - 7 تحريرات هامة متفرقة منها سكت إدريس
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 7 تحريرات هامة متفرقة منها سكت إدريس)', 121);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(481, 'ترك السكت مع القصر والتوسط', 0),
(481, 'السكت مع التوسط فقط', 0),
(481, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(481, 'السكت مع القصر فقط', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً ليعقوب في هاء السكت في نحو (كتابيه) وصلاً؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 7 تحريرات هامة متفرقة منها سكت إدريس)', 121);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(482, 'الحذف قولاً واحداً', 1),
(482, 'الإثبات قولاً واحداً', 0),
(482, 'الحذف والإثبات والمقدم الحذف', 0),
(482, 'الإثبات وصلاً والحذف وقفاً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما الوجه الممتنع عند اجتماع (البدل) مع (العارض للسكون) لورش؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 7 تحريرات هامة متفرقة منها سكت إدريس)', 121);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(483, 'قصر البدل مع إشباع العارض', 0),
(483, 'توسط البدل مع قصر العارض', 1),
(483, 'إشباع البدل مع إشباع العارض', 0),
(483, 'قصر البدل مع قصر العارض', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 7 تحريرات هامة متفرقة منها سكت إدريس)', 121);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(484, 'ترك السكت مع القصر والتوسط', 0),
(484, 'السكت مع التوسط فقط', 0),
(484, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(484, 'السكت مع القصر فقط', 0);


-- Video 122: تحريرات الشاطبية والدرة - 8 تحريرات هؤلاء إن
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 8 تحريرات هؤلاء إن)', 122);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(485, 'ترك السكت مع القصر والتوسط', 0),
(485, 'السكت مع التوسط فقط', 0),
(485, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(485, 'السكت مع القصر فقط', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('كم وجهاً ليعقوب في هاء السكت في نحو (كتابيه) وصلاً؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 8 تحريرات هؤلاء إن)', 122);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(486, 'الحذف قولاً واحداً', 1),
(486, 'الإثبات قولاً واحداً', 0),
(486, 'الحذف والإثبات والمقدم الحذف', 0),
(486, 'الإثبات وصلاً والحذف وقفاً', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما الوجه الممتنع عند اجتماع (البدل) مع (العارض للسكون) لورش؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 8 تحريرات هؤلاء إن)', 122);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(487, 'قصر البدل مع إشباع العارض', 0),
(487, 'توسط البدل مع قصر العارض', 1),
(487, 'إشباع البدل مع إشباع العارض', 0),
(487, 'قصر البدل مع قصر العارض', 0);
INSERT INTO Questions (Title, VideoID) VALUES ('ما هي التحريرات الواجبة عند اجتماع (المد المنفصل) مع (م السكت) لإدريس؟ (تحرير خاص بـ: تحريرات الشاطبية والدرة - 8 تحريرات هؤلاء إن)', 122);
INSERT INTO Choices (QuestionID, Choice, IsTrue) VALUES
(488, 'ترك السكت مع القصر والتوسط', 0),
(488, 'السكت مع التوسط فقط', 0),
(488, 'ترك السكت مع القصر والسكت مع التوسط', 1),
(488, 'السكت مع القصر فقط', 0);
