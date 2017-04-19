CREATE TABLE [dbo].[TipoDatoAux]
(
[Cd_TipDato] [int] NOT NULL IDENTITY(1, 1),
[Nombre] [nvarchar] (60) COLLATE Modern_Spanish_CI_AS NOT NULL,
[DescripDatoCadenaLarga1] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoCadenaLarga2] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoCadenaLarga3] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoCadenaLarga4] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoCadenaLarga5] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoCadenaCorta1] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoCadenaCorta2] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoCadenaCorta3] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoCadenaCorta4] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoCadenaCorta5] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoNumerico1] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoNumerico2] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoNumerico3] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoNumerico4] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoNumerico5] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoBooleano1] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoBooleano2] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoBooleano3] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoBooleano4] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL,
[DescripDatoBooleano5] [nvarchar] (80) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TipoDatoAux] ADD CONSTRAINT [PK_TipoDatoAux] PRIMARY KEY CLUSTERED  ([Cd_TipDato]) ON [PRIMARY]
GO
