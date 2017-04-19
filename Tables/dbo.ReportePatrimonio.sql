CREATE TABLE [dbo].[ReportePatrimonio]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CPtr] [nvarchar] (5) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportePatrimonio] ADD CONSTRAINT [PK_ReportePatrimonio] PRIMARY KEY CLUSTERED  ([RucE], [Ejer], [Cd_CPtr]) ON [PRIMARY]
GO
