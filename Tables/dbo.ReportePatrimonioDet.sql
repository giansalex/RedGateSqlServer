CREATE TABLE [dbo].[ReportePatrimonioDet]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CPtrD] [nvarchar] (5) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CPtr] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[NroCta] [varchar] (15) COLLATE Modern_Spanish_CI_AS NULL,
[IB_esTitulo] [bit] NULL,
[Formula] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportePatrimonioDet] ADD CONSTRAINT [PK_ReportePatrimonioDet] PRIMARY KEY CLUSTERED  ([RucE], [Ejer], [Cd_CPtrD]) ON [PRIMARY]
GO
