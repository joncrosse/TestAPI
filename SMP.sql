CREATE DATABASE SMPDB;

USE SMPDB;

create table Identity(
idnum BIGINT primary key AUTO_INCREMENT, 
handle varchar(100), 
UNIQUE(handle), 
password varchar(100), 
fullname varchar(100) NOT NULL, 
location varchar(100), 
email varchar(100) NOT NULL, 
bdate DATE NOT NULL, 
joined DATE NOT NULL);

CREATE TABLE Story(
sidnum BIGINT primary key AUTO_INCREMENT,
idnum BIGINT, foreign key(idnum) references Identity(idnum),
chapter varchar(100),
url varchar(100),
expires DATETIME,
tstamp TIMESTAMP);

create TABLE Follows(
follower BIGINT, foreign key(follower) references Identity(idnum),
followed BIGINT, foreign key(follower) references Identity(idnum),
tstamp TIMESTAMP);

create TABLE Reprint(
rpnum BIGINT primary key AUTO_INCREMENT,
idnum BIGINT, foreign key(idnum) references Identity(idnum),
sidnum BIGINT, foreign key(sidnum) references Story(sidnum),
likeit boolean,
tstamp TIMESTAMP);

create table Block(
blknum BIGINT primary key AUTO_INCREMENT,
idnum BIGINT, foreign key(idnum) references Identity(idnum),
blocked BIGINT, foreign key(blocked) references Identity(idnum),
tstamp TIMESTAMP);

GRANT ALL ON SMPDB.* TO 'jcr249'@'localhost' IDENTIFIED BY 'jc019396';
GRANT ALL ON SMPDB.* TO 'jcr249'@'%' IDENTIFIED BY 'jc019396';

GRANT ALL ON SMPDB.* TO 'paul'@'localhost' IDENTIFIED BY 'jellydonuts!';  
GRANT ALL ON SMPDB.* TO 'paul'@'belgarath.cs.uky.edu' IDENTIFIED BY 'jellydonuts!';
GRANT ALL ON SMPDB.* TO 'paul'@'paul.cs.uky.edu' IDENTIFIED BY 'jellydonuts!'; 
FLUSH PRIVILEGES;
