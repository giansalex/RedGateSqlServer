CREATE TABLE [dbo].[Formula]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_Fmla] [int] NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_UMP] [int] NOT NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Fecha] [smalldatetime] NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[Proced] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Prin] [bit] NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [varchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA11] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Formula] ADD CONSTRAINT [PK_Formula] PRIMARY KEY CLUSTERED  ([RucE], [ID_Fmla]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Formula] WITH NOCHECK ADD CONSTRAINT [FK_Formula_Prod_UM] FOREIGN KEY ([RucE], [Cd_Prod], [ID_UMP]) REFERENCES [dbo].[Prod_UM] ([RucE], [Cd_Prod], [ID_UMP])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fec ultima Mdf', 'SCHEMA', N'dbo', 'TABLE', N'Formula', 'COLUMN', N'FecMdf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Es Principal', 'SCHEMA', N'dbo', 'TABLE', N'Formula', 'COLUMN', N'IB_Prin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usu ultima Mdf', 'SCHEMA', N'dbo', 'TABLE', N'Formula', 'COLUMN', N'UsuMdf'
GO
