-- phpMyAdmin SQL Dump
-- version 3.5.7
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 10-07-2014 a las 21:02:35
-- Versión del servidor: 5.5.29-0ubuntu0.12.04.2
-- Versión de PHP: 5.3.10-1ubuntu3.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `proyecto`
--
CREATE DATABASE `proyecto` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `proyecto`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Juego`
--

CREATE TABLE IF NOT EXISTS `Juego` (
  `idjuego` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` text NOT NULL,
  `id_obra1` int(11) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '0',
  `ciclico` tinyint(1) NOT NULL DEFAULT '0',
  `borrado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idjuego`),
  KEY `idjuego` (`idjuego`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=120 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Juego_visitante`
--

CREATE TABLE IF NOT EXISTS `Juego_visitante` (
  `id_visitante` int(11) NOT NULL,
  `id_juego` int(11) NOT NULL,
  `puntaje` int(11) NOT NULL,
  `nick_name` varchar(10) NOT NULL DEFAULT 'SinNombre',
  `Finalizado` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Pista`
--

CREATE TABLE IF NOT EXISTS `Pista` (
  `id_obra` int(11) NOT NULL,
  `id_juego` int(11) NOT NULL,
  `id_proxima` int(11) NOT NULL,
  `pista` text NOT NULL,
  PRIMARY KEY (`id_obra`,`id_juego`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Visita`
--

CREATE TABLE IF NOT EXISTS `Visita` (
  `id_visitante` int(10) NOT NULL,
  `id_obra` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contenido_obra`
--

CREATE TABLE IF NOT EXISTS `contenido_obra` (
  `id_contenido` int(11) NOT NULL AUTO_INCREMENT,
  `id_obra` int(11) NOT NULL,
  `audio` varchar(100) NOT NULL DEFAULT 'null',
  `video` varchar(100) NOT NULL DEFAULT 'null',
  `modelo` varchar(100) NOT NULL DEFAULT 'null',
  `texto` varchar(4000) NOT NULL DEFAULT 'null',
  `imagen` varchar(100) NOT NULL DEFAULT 'null',
  `animacion` varchar(1000) NOT NULL DEFAULT 'null=>null=>null=>null=>null=>',
  PRIMARY KEY (`id_contenido`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=308 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contenido_sala`
--

CREATE TABLE IF NOT EXISTS `contenido_sala` (
  `id_contenido` int(11) NOT NULL AUTO_INCREMENT,
  `id_sala` int(11) NOT NULL,
  `audio` varchar(100) NOT NULL DEFAULT 'null',
  `video` varchar(100) NOT NULL DEFAULT 'null',
  `modelo` varchar(100) NOT NULL DEFAULT 'null',
  `texto` varchar(4000) NOT NULL DEFAULT 'null',
  `imagen` varchar(100) NOT NULL DEFAULT 'null',
  KEY `id_contenido` (`id_contenido`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=236 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contenido_zona`
--

CREATE TABLE IF NOT EXISTS `contenido_zona` (
  `id_zona` int(11) NOT NULL,
  `id_conenido` int(11) NOT NULL AUTO_INCREMENT,
  `audio` varchar(200) NOT NULL DEFAULT 'null',
  `video` varchar(200) NOT NULL DEFAULT 'null',
  `modelo` varchar(200) NOT NULL DEFAULT 'null',
  `texto` varchar(4000) NOT NULL DEFAULT 'null',
  `imagen` varchar(200) NOT NULL DEFAULT 'null',
  PRIMARY KEY (`id_conenido`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuest_pregunta`
--

CREATE TABLE IF NOT EXISTS `cuest_pregunta` (
  `id_pregunta` int(11) NOT NULL,
  `id_cuestionario` int(11) NOT NULL,
  `indice_preg` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuestionario`
--

CREATE TABLE IF NOT EXISTS `cuestionario` (
  `id_cuestionario` int(11) NOT NULL AUTO_INCREMENT,
  `nom_cuestionario` varchar(30) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `usuario_creador` int(11) NOT NULL,
  `fecha_creacion` varchar(20) NOT NULL,
  `fecha_desactivacion` text NOT NULL,
  `activo` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_cuestionario`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=24 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuestionario_visitante`
--

CREATE TABLE IF NOT EXISTS `cuestionario_visitante` (
  `id_visitante` int(11) NOT NULL,
  `id_cuestionario` int(11) NOT NULL,
  `id_pregunta` int(11) NOT NULL,
  `respuesta_cerrada` varchar(30) NOT NULL,
  `respuesta_abierta` varchar(300) NOT NULL,
  PRIMARY KEY (`id_visitante`,`id_cuestionario`,`id_pregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descriptor`
--

CREATE TABLE IF NOT EXISTS `descriptor` (
  `id_descriptor` int(11) NOT NULL AUTO_INCREMENT,
  `descriptor` text NOT NULL,
  `id_obra` int(11) NOT NULL,
  PRIMARY KEY (`id_descriptor`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4720 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nan`
--

CREATE TABLE IF NOT EXISTS `nan` (
  `idnan` int(11) NOT NULL AUTO_INCREMENT,
  `texto` text NOT NULL,
  PRIMARY KEY (`idnan`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1966 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `obra`
--

CREATE TABLE IF NOT EXISTS `obra` (
  `nombre_obra` varchar(100) NOT NULL,
  `descripcion_obra` text NOT NULL,
  `id_obra` int(11) NOT NULL AUTO_INCREMENT,
  `descriptor` text NOT NULL,
  `imagen` varchar(100) NOT NULL DEFAULT 'null',
  `id_sala` int(11) NOT NULL,
  `autor` varchar(200) NOT NULL,
  PRIMARY KEY (`id_obra`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=240 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opciones`
--

CREATE TABLE IF NOT EXISTS `opciones` (
  `id_opcion` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) NOT NULL,
  PRIMARY KEY (`id_opcion`,`descripcion`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=29 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opciones_valorOpc`
--

CREATE TABLE IF NOT EXISTS `opciones_valorOpc` (
  `id_opcion` int(11) NOT NULL,
  `id_valorOpcion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preguntas`
--

CREATE TABLE IF NOT EXISTS `preguntas` (
  `id_pregunta` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) NOT NULL,
  `tipo` tinyint(1) NOT NULL,
  `id_opciones` int(11) NOT NULL,
  PRIMARY KEY (`id_pregunta`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=28 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `qr`
--

CREATE TABLE IF NOT EXISTS `qr` (
  `id_qr` int(11) NOT NULL AUTO_INCREMENT,
  `id_obra` int(11) NOT NULL,
  PRIMARY KEY (`id_qr`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sala`
--

CREATE TABLE IF NOT EXISTS `sala` (
  `id_sala` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_sala` text NOT NULL,
  `descripcion_sala` text NOT NULL,
  `qr` varchar(100) NOT NULL DEFAULT 'null',
  PRIMARY KEY (`id_sala`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=200 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE IF NOT EXISTS `usuario` (
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `cedula` varchar(8) NOT NULL,
  `email` varchar(100) NOT NULL,
  `tipoUs` int(11) NOT NULL,
  `nick` varchar(100) NOT NULL,
  `pass` varchar(20) NOT NULL,
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=26 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `valor_opcion`
--

CREATE TABLE IF NOT EXISTS `valor_opcion` (
  `id_val_op` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(30) NOT NULL,
  PRIMARY KEY (`id_val_op`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=61 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `visitante_museo`
--

CREATE TABLE IF NOT EXISTS `visitante_museo` (
  `idvisitante` int(11) NOT NULL AUTO_INCREMENT,
  `nacionalidad` varchar(40) DEFAULT NULL,
  `sexo` varchar(15) DEFAULT NULL,
  `tipo_visita` varchar(40) DEFAULT NULL,
  `rango_edad` varchar(10) DEFAULT NULL,
  `Fecha` text NOT NULL,
  `FechaHora` text NOT NULL,
  PRIMARY KEY (`idvisitante`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=937 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `zona`
--

CREATE TABLE IF NOT EXISTS `zona` (
  `largo` int(10) NOT NULL,
  `ancho` int(10) NOT NULL,
  `x` int(10) NOT NULL,
  `y` int(10) NOT NULL,
  `id_zona` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_zona` text NOT NULL,
  `nombre_obra` varchar(200) NOT NULL,
  PRIMARY KEY (`id_zona`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
