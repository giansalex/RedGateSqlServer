CREATE TABLE [dbo].[Marca]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Mca] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Marca] ADD CONSTRAINT [PK_Marca] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Mca]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Marca] ADD CONSTRAINT [IX_Marca_Ruc_Nom] UNIQUE NONCLUSTERED  ([RucE], [Nombre]) ON [PRIMARY]
GO
