CREATE TABLE [dbo].[Almacen]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Codigo] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Ubigeo] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Direccion] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Encargado] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Telef] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[Capacidad] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[IB_EsVi] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Almacen] ADD CONSTRAINT [PK_Almacen] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Alm]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Almacen] WITH NOCHECK ADD CONSTRAINT [FK_Almacen_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
