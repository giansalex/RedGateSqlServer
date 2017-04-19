CREATE TABLE [dbo].[Actividad]
(
[Cd_Act] [int] NOT NULL,
[Ruc] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nom] [varchar] (300) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (2000) COLLATE Modern_Spanish_CI_AS NULL,
[DescripInc] [varchar] (2000) COLLATE Modern_Spanish_CI_AS NULL,
[FecInc] [datetime] NULL,
[FecInicio] [datetime] NULL,
[HrsEstm] [numeric] (5, 2) NULL,
[HrsReales] [numeric] (5, 2) NULL,
[FecFin] [datetime] NULL,
[Prdad1L2L] [numeric] (3, 2) NULL,
[Prdad4L] [numeric] (3, 2) NULL,
[PorcAvzdo] [numeric] (5, 2) NULL,
[Predec] [int] NULL,
[Cd_TrabEnc] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TrabRsp] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_TA] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_EA] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecReg] [datetime] NOT NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMdf] [datetime] NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Actividad] ADD CONSTRAINT [PK_Actividad] PRIMARY KEY CLUSTERED  ([Cd_Act]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Actividad] ADD CONSTRAINT [FK_Actividad_Actividad] FOREIGN KEY ([Predec]) REFERENCES [dbo].[Actividad] ([Cd_Act])
GO
ALTER TABLE [dbo].[Actividad] ADD CONSTRAINT [FK_Actividad_Empresa] FOREIGN KEY ([Ruc]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[Actividad] ADD CONSTRAINT [FK_Actividad_Usuario] FOREIGN KEY ([UsuCrea]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
ALTER TABLE [dbo].[Actividad] ADD CONSTRAINT [FK_Actividad_Usuario1] FOREIGN KEY ([UsuMdf]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
ALTER TABLE [dbo].[Actividad] ADD CONSTRAINT [FK_Actividad_Usuario2] FOREIGN KEY ([Cd_TrabEnc]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
ALTER TABLE [dbo].[Actividad] ADD CONSTRAINT [FK_Actividad_Usuario3] FOREIGN KEY ([Cd_TrabRsp]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO
