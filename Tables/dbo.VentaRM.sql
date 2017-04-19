CREATE TABLE [dbo].[VentaRM]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroReg] [int] NOT NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TD] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Total] [decimal] (13, 2) NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Usu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [datetime] NOT NULL,
[Cd_Est] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VentaRM] ADD CONSTRAINT [PK_VentaRM] PRIMARY KEY CLUSTERED  ([RucE], [NroReg]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VentaRM] ADD CONSTRAINT [FK_VentaRM_Area] FOREIGN KEY ([RucE], [Cd_Area]) REFERENCES [dbo].[Area] ([RucE], [Cd_Area])
GO
ALTER TABLE [dbo].[VentaRM] ADD CONSTRAINT [FK_VentaRM_Estado] FOREIGN KEY ([Cd_Est]) REFERENCES [dbo].[Estado] ([Cd_Est])
GO
ALTER TABLE [dbo].[VentaRM] ADD CONSTRAINT [FK_VentaRM_Modulo] FOREIGN KEY ([Cd_MR]) REFERENCES [dbo].[Modulo] ([Cd_MR])
GO
ALTER TABLE [dbo].[VentaRM] ADD CONSTRAINT [FK_VentaRM_Moneda] FOREIGN KEY ([Cd_Mda]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
ALTER TABLE [dbo].[VentaRM] ADD CONSTRAINT [FK_VentaRM_TipDoc] FOREIGN KEY ([Cd_TD]) REFERENCES [dbo].[TipDoc] ([Cd_TD])
GO
