CREATE TABLE [dbo].[VentaCfg]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cp] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Valor] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Oblig] [bit] NOT NULL,
[IB_Hab] [bit] NOT NULL
) ON [PRIMARY]
GO
