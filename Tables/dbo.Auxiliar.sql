CREATE TABLE [dbo].[Auxiliar]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Aux] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TDI] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RSocial] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[ApPat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[ApMat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Nom] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Pais] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodPost] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Ubigeo] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Direc] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Telf1] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Telf2] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Fax] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Correo] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[PWeb] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TA] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auxiliar] ADD CONSTRAINT [PK_Auxiliar] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Aux]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auxiliar] WITH NOCHECK ADD CONSTRAINT [FK_Auxiliar_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[Auxiliar] ADD CONSTRAINT [FK_Auxiliar_TipAux] FOREIGN KEY ([Cd_TA]) REFERENCES [dbo].[TipAux] ([Cd_TA])
GO
ALTER TABLE [dbo].[Auxiliar] WITH NOCHECK ADD CONSTRAINT [FK_Auxiliar_TipDocIdn] FOREIGN KEY ([Cd_TDI]) REFERENCES [dbo].[TipDocIdn] ([Cd_TDI])
GO
