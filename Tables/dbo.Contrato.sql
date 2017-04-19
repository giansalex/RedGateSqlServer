CREATE TABLE [dbo].[Contrato]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Ctt] [int] NOT NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prv] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vdr] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[FecIni] [datetime] NULL,
[FecFin] [datetime] NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[UsuMdf] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA11] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA16] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA17] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA18] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA19] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA20] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contrato] ADD CONSTRAINT [PK_Contrato] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Ctt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contrato] ADD CONSTRAINT [FK_Contrato_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
ALTER TABLE [dbo].[Contrato] ADD CONSTRAINT [FK_Contrato_Proveedor2] FOREIGN KEY ([RucE], [Cd_Prv]) REFERENCES [dbo].[Proveedor2] ([RucE], [Cd_Prv])
GO
ALTER TABLE [dbo].[Contrato] ADD CONSTRAINT [FK_Contrato_Vendedor2] FOREIGN KEY ([RucE], [Cd_Vdr]) REFERENCES [dbo].[Vendedor2] ([RucE], [Cd_Vdr])
GO
