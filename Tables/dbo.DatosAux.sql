CREATE TABLE [dbo].[DatosAux]
(
[Cd_DatoAux] [int] NOT NULL IDENTITY(1, 1),
[Cd_TipDato] [int] NOT NULL,
[DatoCadenaLarga1] [nvarchar] (400) COLLATE Modern_Spanish_CI_AS NULL,
[DatoCadenaLarga2] [nvarchar] (400) COLLATE Modern_Spanish_CI_AS NULL,
[DatoCadenaLarga3] [nvarchar] (400) COLLATE Modern_Spanish_CI_AS NULL,
[DatoCadenaLarga4] [nvarchar] (400) COLLATE Modern_Spanish_CI_AS NULL,
[DatoCadenaLarga5] [nvarchar] (400) COLLATE Modern_Spanish_CI_AS NULL,
[DatoCadenaCorta1] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[DatoCadenaCorta2] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[DatoCadenaCorta3] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[DatoCadenaCorta4] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[DatoCadenaCorta5] [nvarchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[DatoNumerico1] [numeric] (20, 10) NULL,
[DatoNumerico2] [numeric] (20, 10) NULL,
[DatoNumerico3] [numeric] (20, 10) NULL,
[DatoNumerico4] [numeric] (20, 10) NULL,
[DatoNumerico5] [numeric] (20, 10) NULL,
[DatoBooleano1] [bit] NULL,
[DatoBooleano2] [bit] NULL,
[DatoBooleano3] [bit] NULL,
[DatoBooleano4] [bit] NULL,
[DatoBooleano5] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DatosAux] ADD CONSTRAINT [PK_DatosAux] PRIMARY KEY CLUSTERED  ([Cd_DatoAux]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DatosAux] ADD CONSTRAINT [FK_DatosAux_TipoDatoAux] FOREIGN KEY ([Cd_TipDato]) REFERENCES [dbo].[TipoDatoAux] ([Cd_TipDato])
GO
