CREATE TABLE [dbo].[Servicio2]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodCo] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[Nombre] [varchar] (200) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[NCorto] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta1] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta2] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Img] [image] NULL,
[Cd_GS] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CGP] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[IC_TipServ] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[UsuCrea] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[Estado] [bit] NOT NULL,
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
[Cta3] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta4] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta5] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta6] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta7] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta8] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Servicio2] ADD CONSTRAINT [PK_Servicio2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Srv]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Servicio2__Ruc_Nombre_TipServ] ON [dbo].[Servicio2] ([RucE], [Nombre], [IC_TipServ]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Servicio2] WITH NOCHECK ADD CONSTRAINT [FK_Servicio2_CCostos] FOREIGN KEY ([RucE], [Cd_CC]) REFERENCES [dbo].[CCostos] ([RucE], [Cd_CC])
GO
ALTER TABLE [dbo].[Servicio2] WITH NOCHECK ADD CONSTRAINT [FK_Servicio2_CCSub] FOREIGN KEY ([RucE], [Cd_CC], [Cd_SC]) REFERENCES [dbo].[CCSub] ([RucE], [Cd_CC], [Cd_SC])
GO
ALTER TABLE [dbo].[Servicio2] WITH NOCHECK ADD CONSTRAINT [FK_Servicio2_CCSubSub] FOREIGN KEY ([RucE], [Cd_CC], [Cd_SC], [Cd_SS]) REFERENCES [dbo].[CCSubSub] ([RucE], [Cd_CC], [Cd_SC], [Cd_SS])
GO
ALTER TABLE [dbo].[Servicio2] WITH NOCHECK ADD CONSTRAINT [FK_Servicio2_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[Servicio2] WITH NOCHECK ADD CONSTRAINT [FK_Servicio2_GrupoSrv] FOREIGN KEY ([RucE], [Cd_GS]) REFERENCES [dbo].[GrupoSrv] ([RucE], [Cd_GS])
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Servicio2', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Producto', 'SCHEMA', N'dbo', 'TABLE', N'Servicio2', 'COLUMN', N'Cd_CGP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Servicio2', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRV0001/SRC0001 (Segun IC_TipServ)', 'SCHEMA', N'dbo', 'TABLE', N'Servicio2', 'COLUMN', N'Cd_Srv'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Servicio2', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fec ultima Mdf', 'SCHEMA', N'dbo', 'TABLE', N'Servicio2', 'COLUMN', N'FecMdf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'v:Venta, c: Compra', 'SCHEMA', N'dbo', 'TABLE', N'Servicio2', 'COLUMN', N'IC_TipServ'
GO
