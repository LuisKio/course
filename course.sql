CREATE USER luis_eduardo PASSWORD 'root';
CREATE DATABASE udemy OWNER luis_eduardo;

CREATE TABLE roles (
	id smallserial,
	name varchar(10) NOT NULL,
	CONSTRAINT pk_roles PRIMARY KEY(id)
);

CREATE TABLE users (
	id smallserial NOT NULL,
	name varchar(50) NOT NULL,
	email varchar(100) NOT NULL,
	password varchar(32) NOT NULL,
	age integer,
	CONSTRAINT pk_users PRIMARY KEY(id)
);

CREATE TABLE rol_user (
	id smallserial NOT NULL,
	id_user integer NOT NULL,
	id_rol integer NOT NULL,
	CONSTRAINT pk_rol_user PRIMARY KEY(id),
	CONSTRAINT fk_user FOREIGN KEY(id_user) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_rol FOREIGN KEY(id_rol) REFERENCES roles(id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE categories (
	id smallserial,
	name varchar(50) NOT NULL,
	CONSTRAINT pk_categories PRIMARY KEY(id)
);

CREATE TABLE courses (
	id smallserial,
	id_teacher integer NOT NULL,
	id_categories integer NOT NULL,
	title varchar(100) NOT NULL,
	description text NOT NULL,
	level varchar(10) NOT NULL,
	CONSTRAINT pk_courses PRIMARY KEY(id),
	CONSTRAINT fk_courses_users FOREIGN KEY(id_teacher) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_courses_categories FOREIGN KEY(id_categories) REFERENCES categories(id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE course_videos (
	id smallserial,
	id_courses integer NOT NULL,
	title varchar(150) NOT NULL,
	url varchar(250) NOT NULL,
	CONSTRAINT pk_course_videos PRIMARY KEY(id),
	CONSTRAINT fk_courses FOREIGN KEY(id_courses) REFERENCES courses(id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
 
CREATE TABLE registered_users (
	id smallserial,
	id_courses integer NOT NULL,
	id_user integer NOT NULL,
	CONSTRAINT pk_registered_users PRIMARY KEY(id),
	CONSTRAINT fk_registered_courses FOREIGN KEY(id_courses) REFERENCES courses(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_registered_user FOREIGN KEY(id_user) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

#INSERT

INSERT INTO roles(name) VALUES('admin'), ('teacher'), ('student');

INSERT INTO users(name, email, password, age) VALUES
	('luis', 'luisla@gmail.com', 'password', 23),
	('eduardo', 'eduardo@gmail.com', 'root', 20);

INSERT INTO users(name, email, password) VALUES
	('bejarano', 'bejarano@gmail.com', 'password'),
	('toloza', 'toloza@gmail.com', 'password');

INSERT INTO rol_user(id_user, id_rol) VALUES(1, 1), (2, 2), (2, 3), (3,2), (4, 3);

INSERT INTO categories(name) VALUES('desarrollo web'), ('desarrollo movil'), ('testeo de software');

INSERT INTO courses(id_teacher, id_categories, title, description, level) VALUES(2, 1, 'Desarrollo Web Completo con HTML5, CSS3, JS AJAX PHP y MySQL', 'Aprende Desarrollo Web con este curso 100% práctico, paso a paso y sin conocimientos previo INCLUYE 4 PROYECTOS FINALES', 'medium'),
(3, 2, 'Crea una app con ChatGPT en Android: Curso completo', 'Agregá inteligencia artificial de ChatGPT a tus aplicaciones Android!', 'easy'),
(3, 3, 'Introducción al Testing de Software: para Principiantes!', 'Aprende las técnicas de testing de software más usadas y los conceptos más importantes, desde cero', 'easy');


INSERT INTO course_videos(id_courses, title, url) VALUES(1, '¿Qué es y que hace un Front End Developer?', 'https://www.academlo.com/videos'),
	(1, '¿Qué es y que hace un Backend Developer?', 'https://www.academlo.com/videos'),
	(1, '¿Qué es y que hace un Full Stack Developer?', 'https://www.academlo.com/videos'),
	(2, '¿Qué es ChatGPT y qué son las Prompts?', 'https://www.academlo.com/videos'),
	(2, 'Playground y Configuracion', 'https://www.academlo.com/videos'),
	(2, 'Documentación de OpenAI/ChatGPT y creando una API Key', 'https://www.academlo.com/videos'),
	(3, 'Roles en el desarrollo de Software', 'https://www.academlo.com/videos');

INSERT INTO registered_users(id_courses, id_user) VALUES(1, 4), (1, 2), (3, 2);

#SELECCIONA LOS USUARIOS Y MUESTRA SU ROL EN LA PAGINA
SELECT roles.name AS role, users.name, users.email, users.age FROM rol_user INNER JOIN users ON rol_user.id_user = users.id  INNER JOIN roles ON rol_user.id_rol = roles.id;
SELECT roles.name AS role, users.name, users.email, users.age FROM rol_user INNER JOIN users ON rol_user.id_user = users.id  INNER JOIN roles ON rol_user.id_rol = roles.id WHERE roles.id = 2;

#SELECCIONA LOS CURSOS QUE IMPARTE UN PROFESOR Y MUESTRA LOS TITULOS DE LOS VIDEOS QUE TIENE EL CURSO
SELECT users.name AS name, roles.name AS rol, categories.name AS category, courses.title, courses.level, course_videos.title  FROM courses INNER JOIN rol_user ON courses.id_teacher = rol_user.id_user INNER JOIN users ON users.id = rol_user.id_user INNER JOIN roles ON roles.id =rol_user.id_rol INNER JOIN categories ON courses.id_categories = categories.id INNER JOIN course_videos ON course_videos.id_courses = courses.id WHERE roles.id = 2;

#MUESTRA LOS USUARIOS QUE ESTAN REGISTRADOS EN X CURSO
SELECT users.name, users.email, courses.title, courses.level FROM registered_users INNER JOIN users ON users.id = registered_users.id_user  INNER JOIN courses ON courses.id = registered_users.id_courses;