CREATE TABLE [dbo].[RMInterno]
(
[Cd_Tab] [char] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroReg] [int] NOT NULL,
[RucE] [varchar] (11) COLLATE Modern_Spanish_CI_AS NULL,
[UsuBD] [varchar] (30) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Est] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecReg] [datetime] NOT NULL,
[UsuSis] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA11] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA16] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA17] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA18] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA19] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA20] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA21] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA22] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA23] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA24] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA25] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA26] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA27] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA28] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA29] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA30] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RMInterno] ADD CONSTRAINT [PK_RMInterno] PRIMARY KEY CLUSTERED  ([Cd_Tab], [NroReg]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RMInterno] ADD CONSTRAINT [FK_RMInterno_Estado] FOREIGN KEY ([Cd_Est]) REFERENCES [dbo].[Estado] ([Cd_Est])
GO
ALTER TABLE [dbo].[RMInterno] ADD CONSTRAINT [FK_RMInterno_Tabla] FOREIGN KEY ([Cd_Tab]) REFERENCES [dbo].[Tabla] ([Cd_Tab])
GO
ALTER TABLE [dbo].[RMInterno] ADD CONSTRAINT [FK_RMInterno_Usuario] FOREIGN KEY ([UsuSis]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
