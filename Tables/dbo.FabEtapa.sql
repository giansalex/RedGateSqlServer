CREATE TABLE [dbo].[FabEtapa]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Fab] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Eta] [int] NOT NULL,
[Cd_Flujo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Prc] [int] NOT NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecIni] [datetime] NULL,
[FecFin] [datetime] NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[Trab] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
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
[IC_Estado] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Porc] [decimal] (7, 4) NULL,
[CantEta] [decimal] (13, 7) NULL,
[HorasTrab] [decimal] (4, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabEtapa] ADD CONSTRAINT [PK_FabEtapa] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Fab], [ID_Eta]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabEtapa] ADD CONSTRAINT [FK_FabEtapa_Almacen] FOREIGN KEY ([RucE], [Cd_Alm]) REFERENCES [dbo].[Almacen] ([RucE], [Cd_Alm])
GO
ALTER TABLE [dbo].[FabEtapa] ADD CONSTRAINT [FK_FabEtapa_FabFabricacion] FOREIGN KEY ([RucE], [Cd_Fab]) REFERENCES [dbo].[FabFabricacion] ([RucE], [Cd_Fab])
GO
ALTER TABLE [dbo].[FabEtapa] ADD CONSTRAINT [FK_FabEtapa_FabProceso1] FOREIGN KEY ([RucE], [Cd_Flujo], [ID_Prc]) REFERENCES [dbo].[FabProceso] ([RucE], [Cd_Flujo], [ID_Prc])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabEtapa', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabEtapa', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'FabEtapa', 'COLUMN', N'Cd_SS'
GO
