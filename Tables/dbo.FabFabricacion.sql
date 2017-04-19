CREATE TABLE [dbo].[FabFabricacion]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Fab] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroFab] [varchar] (40) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Flujo] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[Cant] [decimal] (13, 7) NULL,
[FecEmi] [smalldatetime] NULL,
[FecReq] [smalldatetime] NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Asunto] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Lote] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA11] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA16] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA17] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA18] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA19] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA20] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA21] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA22] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA23] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA24] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA25] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA26] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA27] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA28] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA29] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA30] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabFabricacion] ADD CONSTRAINT [PK_FabFabricacion] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Fab]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabFabricacion] ADD CONSTRAINT [FK_FabFabricacion_FabFlujo] FOREIGN KEY ([RucE], [Cd_Flujo]) REFERENCES [dbo].[FabFlujo] ([RucE], [Cd_Flujo])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabFabricacion', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabFabricacion', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabFabricacion', 'COLUMN', N'Cd_SS'
GO
