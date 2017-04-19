CREATE TABLE [dbo].[Vendedor2]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Vdr] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TDI] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NDoc] [varchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RSocial] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[ApPat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[ApMat] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Nom] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Pais] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Ubigeo] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Direc] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Telf1] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Telf2] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[Correo] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Cargo] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CGV] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Ct] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
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
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecMdf] [datetime] NULL,
[UsuVdr] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Caja] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vendedor2] ADD CONSTRAINT [PK_Vendedor2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Vdr]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vendedor2] ADD CONSTRAINT [IX_Vendedor2__Ruc_TD_NDoc] UNIQUE NONCLUSTERED  ([RucE], [Cd_TDI], [NDoc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vendedor2] ADD CONSTRAINT [FK_Vendedor2_Caja] FOREIGN KEY ([RucE], [Cd_Caja]) REFERENCES [dbo].[Caja] ([RucE], [Cd_Caja])
GO
ALTER TABLE [dbo].[Vendedor2] WITH NOCHECK ADD CONSTRAINT [FK_Vendedor2_Catalogo] FOREIGN KEY ([RucE], [Cd_Ct]) REFERENCES [dbo].[CarteraProd] ([RucE], [Cd_Ct])
GO
ALTER TABLE [dbo].[Vendedor2] WITH NOCHECK ADD CONSTRAINT [FK_Vendedor2_ComisionGrupVdr1] FOREIGN KEY ([RucE], [Cd_CGV]) REFERENCES [dbo].[ComisionGrupVdr] ([RucE], [Cd_CGV])
GO
ALTER TABLE [dbo].[Vendedor2] WITH NOCHECK ADD CONSTRAINT [FK_Vendedor2_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[Vendedor2] WITH NOCHECK ADD CONSTRAINT [FK_Vendedor2_Pais] FOREIGN KEY ([Cd_Pais]) REFERENCES [dbo].[Pais] ([Cd_Pais])
GO
ALTER TABLE [dbo].[Vendedor2] WITH NOCHECK ADD CONSTRAINT [FK_Vendedor2_TipDocIdn] FOREIGN KEY ([Cd_TDI]) REFERENCES [dbo].[TipDocIdn] ([Cd_TDI])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Vendedor', 'SCHEMA', N'dbo', 'TABLE', N'Vendedor2', 'COLUMN', N'Cd_CGV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Cartera Productos', 'SCHEMA', N'dbo', 'TABLE', N'Vendedor2', 'COLUMN', N'Cd_Ct'
GO
