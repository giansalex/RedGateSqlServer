CREATE TABLE [dbo].[FabProceso]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Flujo] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Prc] [int] NOT NULL,
[Nombre] [varchar] (25) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (150) COLLATE Modern_Spanish_CI_AS NULL,
[TipPrc] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Actividades] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabProceso] ADD CONSTRAINT [PK_PrdProceso] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Flujo], [ID_Prc]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FabProceso] ADD CONSTRAINT [FK_PrdProceso_Almacen] FOREIGN KEY ([RucE], [Cd_Alm]) REFERENCES [dbo].[Almacen] ([RucE], [Cd_Alm])
GO
ALTER TABLE [dbo].[FabProceso] ADD CONSTRAINT [FK_PrdProceso_PrdFlujo] FOREIGN KEY ([RucE], [Cd_Flujo]) REFERENCES [dbo].[FabFlujo] ([RucE], [Cd_Flujo])
GO
