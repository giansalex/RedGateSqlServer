CREATE TABLE [dbo].[Banco]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Itm_BC] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ejer] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[NroCta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCtaB] [nvarchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL,
[Cd_EF] [char] (2) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Banco] ADD CONSTRAINT [PK_Banco] PRIMARY KEY CLUSTERED  ([Itm_BC], [RucE]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Banco] ADD CONSTRAINT [FK_Banco_EntidadFinanciera] FOREIGN KEY ([Cd_EF]) REFERENCES [dbo].[EntidadFinanciera] ([Cd_EF])
GO
ALTER TABLE [dbo].[Banco] WITH NOCHECK ADD CONSTRAINT [FK_Banco_Moneda] FOREIGN KEY ([Cd_Mda]) REFERENCES [dbo].[Moneda] ([Cd_Mda])
GO
