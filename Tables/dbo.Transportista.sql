CREATE TABLE [dbo].[Transportista]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Tra] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TDI] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NDoc] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RSocial] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[ApPat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[ApMat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Nom] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Pais] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Ubigeo] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Direc] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Telf] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[LicCond] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[NroPlaca] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[McaVeh] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Transportista] ADD CONSTRAINT [PK_Transportista] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Tra]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Transportista] ADD CONSTRAINT [IX_Transportista_Ruc_TD_NDoc] UNIQUE NONCLUSTERED  ([RucE], [Cd_TDI], [NDoc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Transportista] ADD CONSTRAINT [FK_Transportista_Pais] FOREIGN KEY ([Cd_Pais]) REFERENCES [dbo].[Pais] ([Cd_Pais])
GO
ALTER TABLE [dbo].[Transportista] ADD CONSTRAINT [FK_Transportista_TipDocIdn] FOREIGN KEY ([Cd_TDI]) REFERENCES [dbo].[TipDocIdn] ([Cd_TDI])
GO
EXEC sp_addextendedproperty N'MS_Description', N'TRA0001', 'SCHEMA', N'dbo', 'TABLE', N'Transportista', 'COLUMN', N'Cd_Tra'
GO
