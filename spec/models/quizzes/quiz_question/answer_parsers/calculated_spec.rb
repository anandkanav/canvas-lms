#
# Copyright (C) 2013 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper.rb')
require File.expand_path(File.dirname(__FILE__) + '/answer_parser_spec_helper.rb')

describe Quizzes::QuizQuestion::AnswerParsers::Calculated do
  context "#parse" do
    let(:raw_answers) do
      [
        {
          variables: {"variable_0" => {name: "x", value: "9"} },
          answer_text: 14
        },
        {
          variables: {"variable_0" => {name: "x", value: "6"}},
          answer_text: 11
        },
        {
          variables: {"variable_0" => {name: "x", value: "7"}},
          answer_text: 12
        }
      ]
    end
    let(:parser_class) { Quizzes::QuizQuestion::AnswerParsers::Calculated }
    let(:question_params) do
      {
        question_name: "Formula Question",
        question_type: "calculated_question",
        points_possible: 1,
        question_text: "What is 5 + [x]?",
        formulas: ["5+x"],
        variables: [
          { name: "x", min: 5, max: 10, scale: 0 }
        ]
      }
    end

    before(:each) do
      @question = parser_class.new(Quizzes::QuizQuestion::AnswerGroup.new(raw_answers)).parse(Quizzes::QuizQuestion::QuestionData.new(question_params))
    end

    it "formats formulas for the question" do
      @question[:formulas].each do |formula|
        formula.should be_kind_of(Hash)
      end
    end

    it "formats variables for the question" do
      @question.answers.each do |answer|
        answer[:variables].should be_kind_of(Array)
      end
    end
  end
end
