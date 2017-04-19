CREATE TABLE [dbo].[MaestraPercepciones]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_PercepItem] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[PorcentajePercep] [numeric] (8, 7) NOT NULL,
[TieneFechaVigencia] [bit] NULL,
[FechaVigenciaInicio] [smalldatetime] NULL,
[FechaVigenciaFin] [smalldatetime] NULL,
[UsuCrea] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MaestraPercepciones] ADD CONSTRAINT [PK_MaestraPercepciones] PRIMARY KEY CLUSTERED  ([RucE], [Cd_PercepItem]) ON [PRIMARY]
GO
