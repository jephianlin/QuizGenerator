
import os
import pandas as pd
import random

load('../common_lib.sage')

base = ".." ### the path of QuizGenerator

def tex_writer(info, out_name='tw_output.tex', sol=True, template='basic', seed=None, pdf=False):
    """This function takes 
    ../template-*.tex 
    and replace the placeholders by 
    the corresponding strings  
    provided in info.
        
    Input:
        info: a dictionary containing keys 
            "QUESTION", "SOLUTION", "CHECKCODE", "HEADING", "KEY"
        out_name: a string for the output filename
        template: 'basic' or 'plain'
        seed: random seed
        pdf: boolean
            generate the pdf if True
    Output:
        No output.  This function only generate the file."""
    
    f = open('../template-%s.tex'%template, 'r')
    g = open(out_name, 'w')
    if sol:
        all_filler = ['QUESTION', 'SOLUTION', 'CHECKCODE', 'HEADING', 'KEY']
    else:
        all_filler = ['QUESTION', 'HEADING', 'KEY']
    for line in f:
        for filler in all_filler:
            if line == "%%%%%{}\n".format(filler):
                ### make sure there is no line change in \qrcode{...}
                if line == "%%%%%KEY\n":
                    ind = g.tell()
                    g.seek(ind - 1)
                g.write(info[filler])
                break
        else:
            g.write(line)
    f.close()
    g.close()
    
    print(out_name + " has been generated.")
    
    if pdf:
        print("Trying to compile the tex file.")
        os.system('pdflatex %s'%out_name)
        os.system('pdflatex %s'%out_name)
        print("The pdf file has been generated.")

def create_combiner(out_name, files, pdf=True):
    """Create a tex file for combining
    PDFs in files
    
    Input:
        out_name: string
            name of the output file (including .tex)
        files: list of string
            filenames of the PDFs to be combined
        pdf: boolean
            if True, generate the pdf
    Output:
        No output.  Generate a tex file with filename out_name.  
        Generate the pdf if pdf==True.
    """
    f = open('../template-combiner.tex', 'r')
    g = open(out_name, 'w')
    for line in f:
        if line == "%%%%%START\n":
            for filename in files:
                g.write(r"""\includepdf{%s}
"""%filename)
        else:
            g.write(line)
    f.close()
    g.close()
    
    if pdf:
        os.system('pdflatex %s'%out_name)
        os.system('pdflatex %s'%out_name)
            
class quiz:
    def __init__(self, settings=None):
        """
        settings = {
            "func_name": "MatRep",
            "exam_name": "Quiz 1",
            "course_info": "MATH 104 / GEAI 1209: Linear Algebra II",
        }
        """
        
        if settings == None:
            print("Select the question for the quiz.")
            print("Don't put the quotation marks.")
            print("Here are the choices:")
            qbank = [q.split('.')[0] for q in os.listdir(os.path.join(base,"qbank"))]
            print(qbank)
            self.func_name = input()

            print("Please input exam_name: (e.g., Quiz 1)")
            self.exam_name = input()

            print("Please input course_info: (e.g., MATH 104 / GEAI 1209: Linear Algebra II)")
            self.course_info = input()

            print("Use the default param.")
            print("Use self.func?? to see the default param.")
            print()
            print("All done!")
            print("Use self.print_settings() to see the settings.")
            
        else:
            for key, value in settings.items():
                exec("self.%s = value"%key)
                
        load(os.path.join(base, 'qbank', '%s.sage'%self.func_name))
        self.func = eval(self.func_name)
        
        self.exam_code = self.exam_name.replace(' ', '')

        self.HEADING = r"""\centerline{%s \hfill %s}"""%(self.exam_name, self.course_info)
        
        self.param = None
        
    def print_settings(self):
        for key, value in vars(self).items():
            print(key, ':', value)
            
    def generate(self, pages, sol=True, clean=True):        
        ans = {}
        for num in range(1, pages + 1):
            seed = num
            if self.param == None:
                QUESTION, SOLUTION, CHECKCODE = self.func(seed=seed)
            else:
                QUESTION, SOLUTION, CHECKCODE = self.func(param=self.param, seed=seed)
            
            KEY = r"""%s %3s"""%(self.func_name, seed)
            
            info = {
                "QUESTION": QUESTION, 
                "SOLUTION": SOLUTION, 
                "CHECKCODE": CHECKCODE, 
                "HEADING": self.HEADING, 
                "KEY": KEY
            }
            out_name_q = '%s-%s.tex'%(self.exam_code, num)
            tex_writer(info, out_name=out_name_q, sol=False, seed=seed, pdf=True)
            
            if sol:
                out_name_s = '%s-%s_solution.tex'%(self.exam_code, num)
                tex_writer(info, out_name=out_name_s, sol=True, seed=seed, pdf=True)

            ans[KEY] = CHECKCODE

            s = pd.Series(ans).rename('CHECKCODE')
            s.index.rename('KEY', inplace=True)
            s.to_csv('%s_ans.csv'%self.exam_code, header=True)
            
        print('Start merging...')
        all_questions = ['%s-%s.pdf'%(self.exam_code, j) for j in range(1,pages + 1)]
        create_combiner(out_name='%s.tex'%self.exam_code, files=all_questions)
        
        if sol:
            all_solutions = ['%s-%s_solution.pdf'%(self.exam_code, j) for j in range(1,pages + 1)]
            create_combiner(out_name='%s_solution.tex'%self.exam_code, files=all_solutions)

        if clean:
            print('Cleaning by-proudcts')
            suffix = ['log', 'aux', 'tex']
            prefix = [self.exam_code]
            byproducts = [file for file in os.listdir('.') 
                           if file.split('.')[-1] in suffix or file.split('-')[0] in prefix]
            for file in byproducts:
                os.remove(file)

        print('Process done!')
