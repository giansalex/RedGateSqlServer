CREATE TABLE [dbo].[Lote]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prov] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Lote] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroLote] [varchar] (20) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descripcion] [nvarchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[FecCaducidad] [datetime] NULL,
[UsuCrea] [varchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecModf] [datetime] NULL,
[FecFabricacion] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lote] ADD CONSTRAINT [PK_Lote] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Lote]) ON [PRIMARY]
GO
